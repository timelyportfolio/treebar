HTMLWidgets.widget({

  name: 'treebar',

  type: 'output',

  factory: function(el, width, height) {

    var instance = {};

    return {

      renderValue: function(x) {
        
        instance.x = x;
        
        // rare case but currently a nesting function
        //  in R that I have written will supply
        //  an array, so in case of array, 
        //  we will take the first element
        if(Array.isArray(x.data)) x.data = x.data[0];
        
        // ugly and will fix but for now
        //   empty and re-render in dynamic
        el.innerHTML = "";
        var treebar = new Treebar(el, x.options);
        
        treebar
          .width(el.getBoundingClientRect().width)
          .height(el.getBoundingClientRect().height)
          .data(x.data);
            
        instance.treebar = treebar;
        
      },

      resize: function(width, height) {


      },
      
      instance: instance

    };
  }
});