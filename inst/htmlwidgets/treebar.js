HTMLWidgets.widget({

  name: 'treebar',

  type: 'output',

  factory: function(el, width, height) {

    var instance = {};

    return {

      renderValue: function(x) {
        
        instance.x = x;
        
        // ugly and will fix but for now
        //   empty and re-render in dynamic
        el.innerHTML = "";
          var treebar = new Treebar(el, x.options);
          
          treebar
            .width(el.getBoundingClientRect().width)
            .height(el.getBoundingClientRect().height)
            .data(x.data);
      },

      resize: function(width, height) {

        this.renderValue(instance.x);

      },
      
      instance: instance

    };
  }
});