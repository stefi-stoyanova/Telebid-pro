

  function statusChangeCallback(response) {
  
    if (response.status === 'connected') {
	testAPI();
    } else if (response.status === 'not_authorized') {
     // document.getElementById('status').innerHTML = 'Please log ' +
      //  'into this app.';
    } else {
      //document.getElementById('status').innerHTML = 'Please log ' +
       // 'into Facebook.';
    }
  }

  function checkLoginState() {
    FB.getLoginStatus(function(response) {
      statusChangeCallback(response);
    });
  }

  window.fbAsyncInit = function() {
  FB.init({
    appId      : '1445465279049136',
    cookie     : true,  
    xfbml      : true,  
    version    : 'v2.0' 
  });

  FB.getLoginStatus(function(response) {
    statusChangeCallback(response);
  });

  };


(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/bg_BG/sdk.js#xfbml=1&appId=1445465279049136&version=v2.0";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

/*
  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));
*/

  function testAPI() {
	
	FB.login(function(response) {
		console.log(response);
		
	}, {scope: 'email, user_friends'});
	
	FB.api('/me/taggable_friends', {fields: 'name, picture'}, function(response) {
			console.log(response);
			if(response.data) {
				var str = '<br><br>Your friends: <table border="1">';
				for (var i = 0; i < response.data.length; i++) {
					var url =  response.data[i].picture.data.url ;
					str+= '<tr bgcolor="#FFE8F6"> <td>' + response.data[i].name + '</td><td><img src="' +url + '" width="42" height="42"></td></tr>';
				}
				str+='</table>'
				document.getElementById('status').innerHTML += str;
			} else {
				alert("Error!");
			}
	});
    
	
  }










      
      
      
