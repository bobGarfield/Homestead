(function() {

  this.Resources = (function() {

    function Resources(opts) {
      var list, name, _fn,
        _this = this;
      this.textures = [];
      _fn = function() {
        var image;
        image = new Image;
        image.src = list[name];
        return _this.textures[name] = image;
      };
      for (name in (list = opts.textures)) {
        _fn();
      }
    }

    return Resources;

  })();

}).call(this);
