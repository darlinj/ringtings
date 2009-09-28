$('a').click(function(event){
  alert('Hooray!');
  event.preventDefault(); // Prevent link from following its href
});
    $("p").click(function () { 
      $(this).slideUp(); 
    });
   $("p").hover(function () {
      $(this).addClass("hilite");
    }, function () {
      $(this).removeClass("hilite");
    });

