(function() {

  this.App = (function() {

    function App() {}

    App.prototype.init = function(opts) {
      var canvas, interface, paper, player, storage, textures;
      paper = opts.paper, storage = opts.storage, canvas = opts.canvas, interface = opts.interface;
      textures = opts.resources.textures;
      player = new Player.Hero;
      return this.manager = new Manager({
        'interface': interface,
        'textures': textures,
        'storage': storage,
        'canvas': canvas,
        'player': player,
        'paper': paper
      });
    };

    App.prototype.start = function() {
      return this.manager.start();
    };

    return App;

  })();

}).call(this);
