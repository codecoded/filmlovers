var Bindings = {

  setUser: function(model){
    this.ko_apply(model, 'header')
  },

  setViewContent: function(model){
    this.ko_apply(model, 'viewContent')
  },

  setQueue: function(model){
    this.ko_apply(model, 'footer')
  },

  setQueueListModal: function(model){
    this.ko_apply(model, 'queueListModal')
    $('select', '#queueListModal').on('change', function(e){
      ViewModel.addFilmsToList($('option:selected', $(this)).first().val())
    })
  },

  ko_apply: function(model, elementId){
    ko.applyBindings(model, document.getElementById(elementId))
  },

  ko_data: function(elementId){
    return ko.dataFor(document.getElementById(elementId))
  }
}
