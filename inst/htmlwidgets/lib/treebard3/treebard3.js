var DEFAULT_OPTIONS = {
  margin: { top: 15, right: 15, bottom: 40, left: 60 },
  width: 960,
  height: 500,
  color: d3.scaleOrdinal(d3.schemeCategory10),
  id: "id",
  value: "value",
  tile: "Squarify"
};

var CUSTOM_EVENTS = [
  "nodeClick",
  "nodeMouseover",
  "nodeMouseout",
  "updateComplete"
];

var Treebar = d3Kit.factory.createChart(
  DEFAULT_OPTIONS,
  CUSTOM_EVENTS,
  constructor
);

function constructor(skeleton) {

  var layers = skeleton.getLayerOrganizer();
  var dispatch = skeleton.getDispatcher();
  var options = skeleton.options();

  layers.create(['x-axis', 'y-axis', 'content']);

  var visualize = d3Kit.helper.debounce(function(){
    
    if(!skeleton.hasData()){
      d3Kit.helper.removeAllChildren(layers.get('content'));
      return;
    }
    
    var data = skeleton.data();
    
    var width = skeleton.getInnerWidth();
    var height = skeleton.getInnerHeight();
    
    var root = d3.hierarchy(data)
      .sum(function (d) { return d[options.value] });
      
    var depth1Data = root.children;
    depth1Data.sort(function (a, b) {
      return a.data[options.id] - b.data[options.id]
    });
    
    var svg = layers.get('content');
    
    var color = options.color;
    
    var x0 = d3.scaleBand()
      .domain(
        depth1Data.map(function (d) {
          return d.data[options.id]
        }).sort()
      )
      .range([0, width])
      .padding(0.15);
    
    var x1 = d3.scaleBand()
      .range([0, width])
      .domain(
        d3.set(
          d3.merge(depth1Data.map(
            function (d) {
              var ids = d.data.children.map(function(dd){
                return dd[options.id];
              });
              return ids;
            }
          ))).values()
        )
      .rangeRound([0, x0.bandwidth()])
      .paddingInner(0.1);

    var y = d3.scaleLinear()
      .domain([0, d3.max(depth1Data, function (d) {
          return d3.max(d.children, function (e) { return e.value; });
      })]).nice()
      .range([0,height]);

    var x0Axis = d3.axisBottom()
        .scale(x0)
        .tickSize(0)

    var x1Axis = d3.axisBottom()
        .scale(x1);

    var yAxis = d3.axisLeft()
        .tickSize(-width)
        .scale(y.copy().range([height, 0]));

    layers.get('x-axis')
      .attr('transform', 'translate(0,' + (height + 22) + ')')
      .classed('axis', true)
      .call(x0Axis);

    layers.get('y-axis')
      .classed('axis', true)
      .call(yAxis);
      
    var t = d3.transition();

    update();

    function sum(d) {
      return !options._selected || options._selected === d[options.id] ? d[options.value] : 0;
    }

    function update() {
      root.sum(sum);

      var depth1 = svg.selectAll('.depth1')
        .data(depth1Data, function (d) { return d.data[options.id]; });
      
      depth1 = depth1.enter().append('g')
        .attr('class', 'depth1')
        .merge(depth1)
        .attr('transform', function (d) {
          return 'translate(' + x0(d.data[options.id]) + ',0)';
        });
  
      depth1.each(function(d1){
        var ax1 = d3.select(this).selectAll('.x1.axis').data([0]);
        ax1 = ax1.enter()
          .append('g')
          .merge(ax1);
        ax1.attr('class', 'x1 axis')
          .attr('transform', 'translate(0,' + height + ')')
          .call(x1Axis);
      });

      var depth2Data = d3.merge(depth1Data.map(function (d) { return d.children }));
      
      var depth2Ids = d3.set(
        depth2Data.map(
          function(d){return d.data[options.id]}
        )
      ).values().sort(d3.ascending);
      
      y.domain([0, d3.max(depth2Data.map(function (d) { return d.value }))]).nice();

      // We use a copied Y scale to invert the range for display purposes
      yAxis.scale(y.copy().range([height, 0]));
      layers.get('y-axis').transition(t).call(yAxis);

      var depth2 = depth1.selectAll('.depth2')
        .data(function (d) {
            return d.children;
          },
          function (d) {
            return d.data[options.id];
          }
        );

      depth2 = depth2.enter().append('g')
          .attr('class', 'depth2')
          .merge(depth2)
          .attr('transform', function (d) {
            return 'translate(' + x1(d.data[options.id]) + ',' + height + ')';
          })
          .each(function (d) {
            // UPDATE + ENTER
            // Note that we can use .each on selections as a way to perform operations
            // at a given depth of the hierarchy tree.
            d.children.sort(function (a, b) {
                return depth2Ids.indexOf(b.data[options.id]) -
                    depth2Ids.indexOf(a.data[options.id]);
            })
            d.children.forEach(function (d) {
                d.sort(function (a, b) { return b.value - a.value });
            });
            d.treemap = d3.treemap().tile(d3["treemap" + options.tile]);

            // The treemap layout must be given a root node, so we make a copy of our
            // child node, which creates a new tree from the branch.
            d.treemapRoot = d.copy();
            d.treemap.size([x1.bandwidth(), y(d.value)])(d.treemapRoot);
          });

      // d3.hierarchy gives us a convenient way to access the parent datum. This line
      // adds an index property to each node that we'll use for the transition delay.
      root.each(function (d) {
        d.index = d.parent ? d.parent.children.indexOf(d) : 0
      });

      depth2.transition(t)
        .delay(function (d, i) { return d.parent.index * 150 + i * 50 })
        .attr('transform', function (d) {
            return 'translate(' + x1(d.data[options.id]) + ',' + (height - y(d.value)) + ')';
        });

      var depth3 = depth2.selectAll('.depth3')
          // Note that we're using our copied branch.
          .data(
            function (d) {
              return d.treemapRoot.children;
            },
            function (d) {
              return d.data[options.id];
            }
          );

      depth3 = depth3.enter().append('g')
          .attr('class', 'depth3')
          .merge(depth3);

      var depth4 = depth3.selectAll('.depth4')
        .data(function (d) {
          return d.children;
        },
        function (d) {
          return d.data[options.id];
        });

      var enterDepth4 = depth4.enter().append('rect')
        .attr('class', 'depth4');
          
      depth4 = depth4.merge(enterDepth4)
        .attr('x', function (d) { return d.value ? d.x0 : x1.bandwidth() / 2; })
        .attr('width', function (d) { return d.value ? d.x1 - d.x0 : 0; })
        .attr('y', 0)
        .attr('height', 0)
        .style('fill', function (d) {
          return d.children[0].data.color ? d.children[0].data.color : color(d.parent.data[options.id]);
        });

      depth4
        .on('mouseover', function (d,i) {
          svg.classed('hover-active', true);
          depth4.classed('hover', function (e) {
              return e.data[options.id] === d.data[options.id];
          })
          dispatch.apply('nodeMouseover', this, [d,i]);
        })
        .on('mouseout', function (d,i) {
          svg.classed('hover-active', false);
          depth4.classed('hover', false);
          dispatch.apply('nodeMouseout', this, [d,i]); 
        })
        .on('click', function (d, i) {
          options._selected = options._selected === d.data[options.id] ? null : d.data[options.id];
          dispatch.apply('nodeClick', this, [d,i]);
          update();
        })
        .append('title')
        .text(function (d) { return d.data[options.id] });

      depth4.filter(function (d) { return d.data[options.id] === options._selected })
        .each(function (d) { d3.select(this.parentNode).raise() })
        .raise();

      depth4
        .transition(t)
        .attr('x', function (d) {
          return d.value ? d.x0 : x1.bandwidth() / 2;
        })
        .attr('width', function (d) {
          return d.value ? d.x1 - d.x0 : 0;
        })
        .attr('y', function (d) {
          return d.value ? d.y0 : d.parent.parent.y1 / 2;
        })
        .attr('height', function (d) {
          return d.value ? d.y1 - d.y0 : 0;
        });
    
      dispatch.apply('updateComplete', this, [skeleton]);
    }
  }, 10);

  skeleton
    .autoResize('all')
    .on('options', visualize)
    .on('data', visualize)
    .on('resize', visualize);
}

