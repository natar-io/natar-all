

function getProcess1() {
  var resultElement = document.getElementById('process1');
  
  axios.get('/nectar/info/all')
    .then(function (response) {
	app.content = response.data;
    })
    .catch(function (error) {
      resultElement.innerHTML = generateErrorHTMLOutput(error);
    });

   setTimeout(getProcess1, 5000);
    
}

var app = new Vue({
  el: '#process1',
  data: {
      message: 'Hello Vue!',
      content: { subtree : "" },
      services: function() {
	  return this.content.subtree[0].subtree[0].subtree
      }
  }
})

