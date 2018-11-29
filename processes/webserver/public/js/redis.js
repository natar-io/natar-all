
var redis = new Vue({
    el: '#redis',
    data: {
	form: {
            key: '',
            name: ''
	},
	response: "response",
	show: true
    },
    methods: { 

	onSubmit: function (evt) {
	    evt.preventDefault();

	    axios.get('/nectar/redis/get/' + this.form.key)
		.then(function (response) {
		    // handle success
		    console.log(response);
		    redis.response = response.data;
		})
		.catch(function (error) {
		    // handle error
		    console.log(error);
		})
		.then(function () {
		    // always executed
		});
//	    alert(JSON.stringify(this.form));
	},
	onReset: function (evt) {
	    evt.preventDefault();
	    /* Reset our form values */
	    this.form.email = '';
	    this.form.name = '';
	    this.form.food = null;
	    this.form.checked = [];
	    /* Trick to reset/clear native browser form validation state */
	    this.show = false;
	    this.$nextTick(() => { this.show = true });
	}
	
    }
});

		    
		    


