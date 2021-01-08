export default {
	checkAuth (token) {

		if (token) {

			window.location.href = "/#/dashboard";
			
		} else {
			window.location.href = "/#/login";
		}

	} ,	
}