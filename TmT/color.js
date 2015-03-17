$(document).ready(function() {
  Shiny.addCustomMessageHandler("changeColor",
    function(color) {
      document.body.style.background = color;
	  document.getElementById("timer").style.color = idealTextColor(color);
    }
  );
  Shiny.addCustomMessageHandler("changeFirst",
    function(color) {
		
      document.getElementById("first").style.backgroundColor = color;
	  document.getElementById("first").style.color = idealTextColor(color);
    }
  );
   Shiny.addCustomMessageHandler("changeSecond",
    function(color) {
      document.getElementById("second").style.backgroundColor = color;
	  document.getElementById("second").style.color = idealTextColor(color);
    }
  );
    Shiny.addCustomMessageHandler("changeThird",
    function(color) {
      document.getElementById("third").style.backgroundColor = color;
	  document.getElementById("third").style.color = idealTextColor(color);

    }
  );
  function getRGBComponents(color) {       

    var r = color.substring(1, 3);
    var g = color.substring(3, 5);
    var b = color.substring(5, 7);

    return {
       R: parseInt(r, 16),
       G: parseInt(g, 16),
       B: parseInt(b, 16)
    };
}
  function idealTextColor(bgColor) {

   var nThreshold = 105;
   var components = getRGBComponents(bgColor);
   var bgDelta = (components.R * 0.299) + (components.G * 0.587) + (components.B * 0.114);
   return ((255 - bgDelta) < nThreshold) ? "#000000" : "#ffffff";
}
});