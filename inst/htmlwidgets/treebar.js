HTMLWidgets.widget({

  name: 'treebar',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        d3.json("lib/treebard3-0.1/data.json", draw);
        function draw(error, data) {
          if(error) throw(error);
          
          var treebar = new Treebar(el).data(data);
        }
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});