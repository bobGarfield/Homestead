(function() {
  var all, down, left, leftButton, makeJumpKey, openJournalKey, right, rightButton, toLeft, toRight, up, walkLeftKey, walkRightKey;

  all = 4;

  left = -5;

  right = 5;

  up = 50;

  down = 5;

  toLeft = [left, 0].point();

  toRight = [right, 0].point();

  walkLeftKey = 'a';

  walkRightKey = 'd';

  openJournalKey = 'j';

  makeJumpKey = 'space';

  leftButton = 0;

  rightButton = 2;

  this.Manager = (function() {

    function Manager(opts) {
      var canvas, paper;
      this.opts = opts;
      canvas = opts.canvas, paper = opts.paper;
      paper.setup(canvas);
      paper.install(this);
    }

    Manager.prototype.start = function() {
      var interface, player, storage, _ref;
      _ref = this.opts, interface = _ref.interface, player = _ref.player, storage = _ref.storage;
      this.location = storage.current;
      interface.container = player.inventory.container;
      this.view.resetCamera();
      this.buildLocation();
      this.spawnPlayer();
      this.defineLoop();
      this.defineMouseHandlers();
      return this.defineKeyboardHandlers();
    };

    Manager.prototype.defineKeyboardHandlers = function() {
      var interface, journal, player, textures, _ref,
        _this = this;
      _ref = this.opts, interface = _ref.interface, player = _ref.player, textures = _ref.textures;
      journal = interface.elements.journal;
      this.tool.onKeyDown = function(event) {
        if (event.key === walkRightKey) player.shape.image = textures.playerRun;
        if (event.key === walkLeftKey) {
          return player.shape.image = textures.playerRunLeft;
        }
      };
      return this.tool.onKeyUp = function(event) {
        if (event.key === walkRightKey) player.shape.image = textures.player;
        if (event.key === walkLeftKey) {
          return player.shape.image = textures.playerLeft;
        }
      };
    };

    Manager.prototype.defineMouseHandlers = function() {
      var player,
        _this = this;
      player = this.opts.player;
      return this.tool.onMouseDown = function(event) {
        var button, camera, id, inventory, location, point, shape;
        location = _this.location;
        camera = _this.view.camera.x;
        point = event.point.clone();
        point.x += camera - location.cellSize / 4;
        button = event.event.button;
        inventory = player.inventory;
        switch (button) {
          case leftButton:
            id = location.blockAt(point);
            inventory.put(id);
            return location.destroyBlockAt(point);
          case rightButton:
            if (!location.blockAt(point)) {
              id = inventory.takeBlock();
              shape = _this.makeBlock(id);
              return location.putBlockTo(point, id, shape);
            }
        }
      };
    };

    Manager.prototype.defineLoop = function() {
      var key, player, storage, _ref,
        _this = this;
      _ref = this.opts, player = _ref.player, storage = _ref.storage;
      key = this.Key;
      return this.view.onFrame = function() {
        var camera, location, side;
        location = _this.location;
        camera = _this.view.camera;
        if (key.isDown(walkRightKey)) {
          if (location.checkX(player.head, 0) && location.checkX(player.body, 0)) {
            player.move(right);
            if ((side = location.checkBorder(player.body))) {
              if (storage.follow(side)) {
                _this.rebuildLocation();
                _this.respawnPlayerFrom('left');
                _this.view.cancelTranslation();
              }
            }
            if ((camera.x + _this.view.size.width) / location.cellSize < location.width) {
              _this.view.translate(toRight);
            }
          }
        }
        if (key.isDown(walkLeftKey)) {
          if (location.checkX(player.head, -1) && location.checkX(player.body, -1)) {
            player.move(left);
            if ((side = location.checkBorder(player.body))) {
              if (storage.follow(side)) {
                _this.rebuildLocation();
                _this.respawnPlayerFrom('right');
                _this.view.translate(location.points.end);
              }
            }
            if (camera.x > 0) _this.view.translate(toLeft);
          }
        }
        if (location.checkY(player.body, 1)) {
          player.fall(down);
          return;
        }
        if (key.isDown(makeJumpKey)) {
          if (location.checkY(player.head, -1)) return player.jump(up);
        }
      };
    };

    Manager.prototype.spawnPlayer = function() {
      var player, point, points, texture, textures, _ref;
      _ref = this.opts, player = _ref.player, textures = _ref.textures;
      points = this.location.points;
      texture = textures.player;
      point = points.left.clone();
      player.shape = new this.Raster(texture);
      return player.spawn(point);
    };

    Manager.prototype.respawnPlayerFrom = function(side) {
      var player, point, points;
      player = this.opts.player;
      points = this.location.points;
      point = points[side].clone();
      point.y = player.body.y;
      return player.spawn(point);
    };

    Manager.prototype.buildLocation = function() {
      var height, location, width,
        _this = this;
      location = this.location;
      height = location.height;
      width = location.width;
      return height.times(function(y) {
        return width.times(function(x) {
          var id, point, relative, shape;
          relative = [x, y].point();
          point = location.absoluteFrom(relative);
          if (id = location.blockAt(point)) {
            shape = _this.makeBlock(id);
            return location.spawnBlockAt(point, shape);
          }
        });
      });
    };

    Manager.prototype.rebuildLocation = function() {
      var player, storage, _ref;
      _ref = this.opts, storage = _ref.storage, player = _ref.player;
      this.location.destroy();
      this.location = storage.current;
      return this.buildLocation();
    };

    Manager.prototype.makeBlock = function(id) {
      var kind, texture, textures;
      textures = this.opts.textures;
      kind = all.rand();
      switch (id) {
        case 'dirt':
          texture = textures["dirt" + kind];
          return new this.Raster(texture);
        case 'stone':
          texture = textures["stone" + kind];
          return new this.Raster(texture);
        default:
          return null;
      }
    };

    return Manager;

  })();

}).call(this);
