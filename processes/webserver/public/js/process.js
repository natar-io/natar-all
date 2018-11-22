

function getProcess1() {
  var resultElement = document.getElementById('process1');
    
  axios.get('/nectar/info/all')
    .then(function (response) {
	app.content = response.data;
    })
    .catch(function (error) {
      resultElement.innerHTML = generateErrorHTMLOutput(error);
    });
//     setTimeout(getProcess1, 5000);
    
}

// setTimeout(getProcess1, 5000);


var app = new Vue({
    el: '#process1',
    data: {
	message: 'Hello Vue!',
	content: { subtree : "" },
	
	// Alerts 
	dismissSecs: 5,
	dismissCountDown: 0,
	fields: [
            // A virtual column that doesn't exist in items
            'name',
	    { key: 'start', label: 'Actions' },
	    'state',
	    // 'state', 'type',
	    'resources', 'state_reason'
	],
	alert_text: "",
	services: function() {
	    return this.content.subtree[0].subtree[0].subtree
	}

    },
    methods: { 
	sendServiceCommand: function(serviceId, command){
	    //	  alert(service + " " + command);
	    let name = this.services()[serviceId].name

	    
	    axios.get('/nectar/service/' + name + '/' + command)
		.then(function (response) {
		    app.alert_text = response.data;
		    app.showAlert();
		    setTimeout(getProcess1, 5000);
		})

	    
	},
	countDownChanged: function(dismissCountDown) {
	    this.dismissCountDown = dismissCountDown
	},
	showAlert: function() {
	    this.dismissCountDown = this.dismissSecs
	}
    }
})

