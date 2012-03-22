(function() {

  this.App = (function() {

    function App() {}

    App.prototype.init = function(opts) {
      var canvas, interface, map, matrix, paper, player, resources;
      paper = opts.paper, matrix = opts.matrix, canvas = opts.canvas, resources = opts.resources, interface = opts.interface;
      map = new Map(matrix);
      player = new Player.Hero;
      return this.manager = new Manager({
        interface: interface,
        textures: resources.textures,
        canvas: canvas,
        player: player,
        paper: paper,
        map: map
      });
    };

    App.prototype.start = function() {
      return this.manager.start();
    };

    return App;

  })();

}).call(this);
