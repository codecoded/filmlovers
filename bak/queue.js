var Queue = {

  init: function()
  {
    $("#foo2").carouFredSel({
      circular: false,
      infinite: false,
      auto  : false,
      prev  : { 
        button: "#foo2_prev",
        key: "left"
      },
      next: { 
          button: "#foo2_next",
          key: "right"
        },
      pagination: "#foo2_pag"
    })
  }
}
