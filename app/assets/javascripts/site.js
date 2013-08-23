jQuery(document).ready(function($) {
	
	var slideTime = 700;
	if (!Modernizr.svg) {
	  $(".logo img").attr("src", "img/site-basics/filmlovers-logo.png");
	}
	
	// hide all the div elements with panels in the class name
  $("div[id^='panels']").hide();

  // toggles the divs on click of the links
  $('.showPanel').click(function(e) {
		
		e.preventDefault();

	   // show the clicked div
		var ident = $(this).attr('data-rel');
		
		if ($('#panels' + ident).hasClass("current")) {
			$("div[id^='panels']").slideUp(slideTime);
			$("div[id^='panels']").removeClass("current");
		} else {
			// hide all the divs
	   	$("div[id^='panels']").slideUp(slideTime);
			$("div[id^='panels']").removeClass("current");
			$('#panels' + ident).slideDown(slideTime);
			$('#panels' + ident).addClass("current");
		}
   	return false;
	});
	
	function filterPath(string) {
	  return string
		.replace(/^\//,'')
		.replace(/(index|default).[a-zA-Z]{3,4}$/,'')
		.replace(/\/$/,'');
	 }

  var locationPath = filterPath(location.pathname);
  var scrollElem = scrollableElement('html', 'body');
	 
	 $('a[href*=#]').each(function() {
		var thisPath = filterPath(this.pathname) || locationPath;
		if (locationPath == thisPath && (location.hostname == this.hostname || !this.hostname) && this.hash.replace(/#/,'') ) {
		  var $target = $(this.hash), target = this.hash;
		  if ($target && $target.offset()!==undefined) {
				var targetOffset = $target.offset().top;
				$(this).click(function(event) {
			 	 	event.preventDefault();
			  	$(scrollElem).animate({scrollTop: targetOffset}, slideTime, function() {
					location.hash = target;
			  });
			});
		 }
		}
	});
	 
	  // use the first element that is "scrollable"
	  function scrollableElement(els) {
		for (var i = 0, argLength = arguments.length; i <argLength; i++) {
		  var el = arguments[i],
			  $scrollElement = $(el);
		  if ($scrollElement.scrollTop()> 0) {
			return el;
		  } else {
			$scrollElement.scrollTop(1);
			var isScrollable = $scrollElement.scrollTop()> 0;
			$scrollElement.scrollTop(0);
			if (isScrollable) {
			  return el;
			}
		  }
		}
		return [];
	  }


});