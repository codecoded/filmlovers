FL = {
  counter: function(id){
    var self = this;
    self.id = id;

    var counter = $("label[for='" + id + "']");

    self.val = function(){
      return parseInt(counter.text());
    }

    self.decr = function(){
      return self.set(self.val() - 1);
    }

    self.incr = function(){
      return self.set(self.val() + 1);
    }

    self.set = function(val){
      return counter.text(val);
    }
    return self;
  }
}