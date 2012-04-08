(function() {
  var interpret, space;

  space = /\s/;

  interpret = function(string) {
    var arr;
    arr = string.split(space);
    arr.each(function(row, index) {
      return arr[index] = row.split('');
    });
    return arr;
  };

  namespace("Map", function() {
    var Location;
    Location = this.Location;
    return this.Storage = (function() {

      function Storage() {
        this.maps = [];
      }

      Storage.prototype.follow = function(side) {
        var current, index, map, maps;
        maps = this.maps, current = this.current;
        index = current.index;
        maps[index] = current;
        if ((map = maps[index + side])) {
          this.current = map;
          return true;
        }
      };

      Storage.prototype.load = function(maps) {
        maps.each(function(mesh, index) {
          var map, matrix;
          matrix = interpret(mesh);
          map = new Location(matrix, index);
          return maps[index] = map;
        });
        this.maps = maps;
        return this.current = maps.first;
      };

      return Storage;

    })();
  });

}).call(this);
