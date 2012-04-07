(function() {
  var draw;

  if (typeof global === "undefined" || global === null) global = window;

  global.swap = function(one, two) {
    var temp;
    temp = one;
    one = two;
    return two = temp;
  };

  global.namespace = function(name, body) {
    var space, _ref;
    space = (_ref = this[name]) != null ? _ref : this[name] = {};
    if (space.namespace == null) space.namespace = global.namespace;
    return body.call(space);
  };

  Function.prototype.set = function(prop, callback) {
    return this.prototype.__defineSetter__(prop, callback);
  };

  Function.prototype.get = function(prop, callback) {
    return this.prototype.__defineGetter__(prop, callback);
  };

  Function.prototype.both = function(prop, opts) {
    this.prototype.__defineSetter__(prop, opts.set);
    return this.prototype.__defineGetter__(prop, opts.get);
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

  Array.prototype.each = Array.prototype.forEach;

  Array.both('first', {
    get: (function() {
      return this[0];
    }),
    set: (function(val) {
      return this[0] = val;
    })
  });

  Array.both('last', {
    get: (function() {
      return this[this.length];
    }),
    set: (function(val) {
      return this[this.length] = val;
    })
  });

  Array.both('second', {
    get: (function() {
      return this[1];
    }),
    set: (function(val) {
      return this[1] = val;
    })
  });

  Array.both('penult', {
    get: (function() {
      return this[this.length - 1];
    }),
    set: (function(val) {
      return this[this.length - 1] = val;
    })
  });

  global.$ = function(query) {
    return global.document.querySelector(query);
  };

  global.$$ = function(query) {
    return global.document.querySelectorAll(query);
  };

  global.toggleDisplay = function(element, type) {
    return element.style.display = type;
  };

  global.preventDefaults = function(element, event) {
    return element[event] = function() {
      return false;
    };
  };

  global.make = function(tag, className, id) {
    var elem;
    if (className == null) className = '';
    if (id == null) id = '';
    elem = global.document.createElement(tag);
    elem.id = id;
    elem.className = className;
    return elem;
  };

  global.resetClassNamesFor = function(elements) {
    return elements.each(function(element) {
      return element.className = '';
    });
  };

  NodeList.prototype.each = Array.prototype.each;

  HTMLCollection.prototype.each = Array.prototype.each;

  global.removeRowsFrom = function(table) {
    var _results;
    _results = [];
    while (table.rows.length) {
      _results.push(table.deleteRow(0));
    }
    return _results;
  };

  Array.prototype.point = function() {
    return new global.paper.Point(this);
  };

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
    x = point.x, y = point.y;
    this._context.translate(-x, -y);
    this.camera.x += x;
    return this.camera.y += y;
  };

  global.paper.View.prototype.translateTo = global.paper.View.prototype.translate;

  global.paper.View.prototype.resetCamera = function() {
    return this.camera = [0, 0].point();
  };

  global.paper.View.prototype.cancelTranslation = function() {
    this.translate(this.camera.multiply(-1));
    return this.resetCamera();
  };

  global.paper.View.prototype.applyTranslation = function() {
    return this.translate(this.camera);
  };

  global.paper.Point.prototype.multiply = function(n) {
    return new global.paper.Point(this.x * n, this.y * n);
  };

  global.paper.Point.prototype.divide = function(n) {
    return new global.paper.Point(this.x / n, this.y / n);
  };

  global.paper.Point.prototype.floor = function() {
    return new global.paper.Point(this.x.floor(), this.y.floor());
  };

}).call(this);
