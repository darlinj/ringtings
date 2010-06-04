/*
 * Tiny Carousel 1.75
 *
 * Copyright (c) 2010 Maarten Baijs
 *
 * Date: 24 / 05 / 2010
 * Library: jQuery
 *
 */
(function($){
	$.fn.tinycarousel = function(options){
		var defaults = { 
			start: 1, // where should the carousel start?
			display: 1, // how many blocks do you want to move at 1 time?
			axis: 'x', // vertical or horizontal scroller? ( x || y ).
			controls: true, // show left and right navigation buttons.
			pager: false, // is there a page number navigation present?
			interval: false, // move to another block on intervals.
			intervaltime: 5000, // interval time in milliseconds.
			animation: true, // false is instant, true is animate.
			duration: 1000, // how fast must the animation move in ms?
			callback: null // function that executes after every move
		};
		var options = $.extend(defaults, options);  

		var oSlider = $(this);
		var oViewport = $('.viewport', oSlider);
		var oContent = $('.overview', oSlider);
		var oPages = oContent.children();
		var oBtnNext = $('.next', oSlider);
		var oBtnPrev = $('.prev', oSlider);
		var oPager = $('.pager', oSlider);
		var iPageSize, iSteps, iCurrent, oTimer, bForward = true, bAxis = options.axis == 'x';

		return this.each(function(){
			initialize();
		});
		function initialize(){
			iPageSize = bAxis ? $(oPages[0]).outerWidth(true) : $(oPages[0]).outerHeight(true);
			var iLeftover = Math.ceil(((bAxis ? oViewport.outerWidth() : oViewport.outerHeight()) / (iPageSize * options.display)) -1);
			iSteps = Math.max(1, Math.ceil(oPages.length / options.display) - iLeftover);
			iCurrent = Math.min(iSteps, Math.max(1, options.start)) -2;
			oContent.css(bAxis ? 'width' : 'height', (iPageSize * oPages.length));
			move(1);
			setEvents();
		}
		function setButtons(){
			if(options.controls){
				oBtnPrev.toggleClass('disable', !(iCurrent > 0));
				oBtnNext.toggleClass('disable', !(iCurrent +1 < iSteps));
			}
		}
		function setEvents(){
			if(options.controls && oBtnPrev.length > 0 && oBtnNext.length > 0){
				oBtnPrev.click(function(){move(-1); clearInterval(oTimer); return false;});
				oBtnNext.click(function(){move( 1); clearInterval(oTimer); return false;});
			}
			if(options.pager && oPager.length > 0){
				oPager.click(setPager);
			}
		}
		function setPager(oEvent){
			var oTarget = oEvent.target;
			if($(oTarget).hasClass('pagenum')){
				iCurrent = parseInt(oTarget.rel) -1;
				move(1);
			}
			return false;
		}
		function setPagerActive(){
			if(options.pager){
				var oNumbers = $('.pagenum', oPager);
				oNumbers.removeClass('active');
				$(oNumbers[iCurrent]).addClass('active');
			}
		}
		function setTimer(bReset){
			if(options.interval && !bReset){
				clearInterval(oTimer);
				oTimer = window.setInterval(function(){
					bForward = iCurrent +1 == iSteps ? false : iCurrent == 0 ? true : bForward;
          //if (bForward) {
          //{
       if (! bForward ){
        clearInterval(oTimer);
      }
      else {
     //move(1, true);
          move(bForward ? 1 : -1, true);
          }
          //}
				}, options.intervaltime);
			}
		}
		function move(iDirection, bTimerReset){
			
			if(iCurrent > 0 || iCurrent +1 < iSteps){
				iCurrent += iDirection;
				var oPosition = {};
				oPosition[bAxis ? 'left' : 'top'] = -(iCurrent * (iPageSize * options.display));
						
				oContent.animate(oPosition,{
					queue: false,
					duration: options.animation ? options.duration : 0,
					complete: function(){
						if(typeof options.callback == 'function')
						options.callback.call(this, oPages[iCurrent], iCurrent);
					}
				});
				setButtons();
				setPagerActive();
        setTimer(bTimerReset);
			}
		}
	};
})(jQuery);
