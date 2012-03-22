(function() {

  namespace('Items', function() {
    return this.Container = (function() {

      function Container() {
        this.blocks = [];
        this.items = [];
      }

      return Container;

    })();
  });

}).call(this);
