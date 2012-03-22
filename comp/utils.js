(function() {
  var draw;

  if (typeof global === "undefined" || global === null) global = window;

  global.$ = function(query) {
    return global.document.querySelector(query);
  };

  global.toggleDisplay = function(element, type) {
    return element.style.display = type;
  };

  global.preventDefaults = function(element, event) {
    return element[event] = function() {
      return false;
    };
  };

  global.make = function(tag) {
    return global.document.createElement(tag);
  };

  Number.prototype.rand = function() {
    return Math.floor(Math.random() * this);
  };

  Number.prototype.times = function(callback) {
    var i;
    for (i = 0; i < this; i += 1) {
      callback(i);
    }
  };

  Number.prototype.floor = function() {
    return Math.floor(this);
  };

  Number.prototype.round = function() {
    return Math.round(this);
  };

  global.namespace = function(name, body) {
    var space, _ref;
    space = (_ref = this[name]) != null ? _ref : this[name] = {};
    if (space.namespace == null) space.namespace = global.namespace;
    return body.call(space);
  };

  Array.prototype.point = function() {
    return new global.paper.Point(this);
  };

  Array.prototype.each = function() {};

  draw = global.paper.Project.prototype.draw;

  global.paper.Project.prototype.draw = function(context, matrix) {
    var camera, size;
    camera = this.view.camera;
    size = this.view.size;
    context.clearRect(camera.x, camera.y, size.width, size.height);
    return draw.call(this, context, matrix);
  };

  global.paper.View.prototype.translate = function(point) {
    var x, y;
    x = point.x;
    y = point.y;
    this._context.translate(x, y);
    this.camera.x -= x;
    return this.camera.y -= y;
  };

  global.paper.Point.prototype.multiply = function(n) {
    return new global.paper.Point(this.x * n, this.y * n);
  };

  global.paper.Point.prototype.floor = function() {
    return new global.paper.Point(this.x.floor(), this.y.floor());
  };

  Function.prototype.set = function(prop, callback) {
    return this.prototype.__defineSetter__(prop, callback);
  };

  Function.prototype.get = function(prop, callback) {
    return this.prototype.__defineGetter__(prop, callback);
  };

  Function.prototype.duo = function(prop, opts) {
    this.prototype.__defineSetter__(prop, opts.set);
    return this.prototype.__defineGetter__(prop, opts.get);
  };

}).call(this);
