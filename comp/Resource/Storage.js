(function() {

  namespace("Resource", function() {
    return this.Storage = (function() {

      function Storage() {}

      Storage.prototype.load = function(opts) {
        var image, list, name, textures;
        textures = {};
        for (name in (list = opts.textures)) {
          image = new Image;
          image.src = list[name];
          textures[name] = image;
        }
        return this.textures = textures;
      };

      return Storage;

    })();
  });

}).call(this);
