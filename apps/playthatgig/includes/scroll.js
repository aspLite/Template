var scrollStarted=0;
var intervalId;
var scrollDistance = 1;
var intervalTimeout=130;
var buttons;

function scrollpage(el) {
	
	if (intervalTimeout<50) {intervalTimeout=50};
	if (intervalTimeout>200) {intervalTimeout=200};
	
	if (scrollStarted==1){
		
			clearInterval(intervalId);
			scrollStarted=0;
			
			buttons = document.getElementsByClassName("autoscroll");
			for (var i = 0; i < buttons.length; i++) {
			  buttons.item(i).innerHTML='AutoScroll';
			};
			
			buttons = document.getElementsByClassName("tweak");
			for (var i = 0; i < buttons.length; i++) {
			  buttons.item(i).style.visibility='hidden';
			}; 		
			
			return false
		};
		
	scrollStarted=1;		
	
	buttons = document.getElementsByClassName("autoscroll");
	for (var i = 0; i < buttons.length; i++) {
	  buttons.item(i).innerHTML='Stop AutoScroll';
	};
	
	buttons = document.getElementsByClassName("tweak");
	for (var i = 0; i < buttons.length; i++) {
	  buttons.item(i).style.visibility='visible';
	}; 	
	

	intervalId = setInterval(function() {	
	window.scrollTo(0, window.pageYOffset + scrollDistance,);
	}, intervalTimeout);
	
}