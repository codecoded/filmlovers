FL = {
  counter: function(id){
    var self = this;
    self.id = id;

    var counter = $("[data-counter='" + id + "']");

    self.val = function(){
      return parseInt(counter.text());
    }

    self.decr = function(){
      return self.set(self.val() - 1);
    }

    self.incr = function(){
      return self.set(self.val() + 1);
    }

    self.change = function(amount){
      return self.set(self.val() + amount);
    }

    self.set = function(val){
      return counter.text(val);
    }

    self.animate = function(){

    }
    return self;
  }
};