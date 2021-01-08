<template>
	<v-container>
		<v-row>
			<v-col cols="12" sm="6">
				<v-card>
					<v-card-title> My Profile </v-card-title>
					<v-card-text>
						<v-row>
							<v-col cols="12">
								<v-text-field
									v-model="fname"
									type="text"
									label="First Name"
									:color="color">
								</v-text-field>
								
								<v-text-field
									v-model="lname"
									label="Last Name"
									:color="color">
								</v-text-field>
								
								<v-text-field
									v-model="username"
									label="Username"
									:color="color"
									hide-details>
								</v-text-field>
							</v-col>
						</v-row>
						
						<v-row
							justify="end">
							<v-btn :color="color" class="mt-2 mr-3" dark @click="updateProfile"> Update </v-btn>
						</v-row>
					</v-card-text>
				</v-card>
			</v-col>

			<v-col cols="12" sm="6">
				<v-card>
					<v-card-title> Change Password </v-card-title>
					<v-card-text>
						<v-row>
							<v-col cols="12">
								<v-text-field
									v-model="old_password"
									label="Old Password"
									:append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
									:type="show1 ? 'text' : 'password'"
									@click:append="show1 = !show1"
									:color="color">
								</v-text-field>
								
								<v-text-field
									v-model="new_password"
									label="New Password"
									:append-icon="show2 ? 'mdi-eye' : 'mdi-eye-off'"
									:type="show2 ? 'text' : 'password'"
									@click:append="show2 = !show2"
									:color="color">
								</v-text-field>
								
								<v-text-field
									v-model="verify_password"
									label="Verify Password"
									:append-icon="show3 ? 'mdi-eye' : 'mdi-eye-off'"
									:type="show3 ? 'text' : 'password'"
									@click:append="show3 = !show3"
									:color="color"
									hide-details>
								</v-text-field>
							</v-col>
						</v-row>
						
						<v-row
							justify="end">
							<v-btn :color="color" class="mt-2 mr-3" dark @click="changePass"> Change </v-btn>
						</v-row>
					</v-card-text>
				</v-card>
			</v-col>
		</v-row>
	</v-container>
</template>

<script>
	import { API , token } from '../main'

	export default {
		data () {
			return {
				color: null ,
				fname: "" ,
				lname: "" ,
				username: "" ,

				old_password: "" ,
				new_password: "" ,
				verify_password: "" ,
				show1: false ,
				show2: false ,
				show3: false ,

				namePattern: /^[A-Za-z -]*$/
			}
		} ,

		methods: {
			getMyProfile () {
				fetch(API + '/get/my/profile/' + token)
				.then(response => response.json())
				.then(data => {
					this.fname    = data[0].fname;
					this.lname    = data[0].lname;
					this.username = data[0].username; 
				});
			} ,

			getActiveColor () {
				fetch(API + '/get/active/color/' + token)
				.then(response => response.json())
				.then(data => {
					this.color = data[0].color;
				});
			} ,

			updateProfile () {

				let updateProfile = {
					user_id : token ,
					fname   : this.fname ,
					lname   : this.lname ,
					username: this.username ,
				};

				if (!updateProfile.fname.trim() || !updateProfile.lname.trim() || !updateProfile.username.trim()) {

					this.$swal(
						'ERROR' , 
						'All fields are required' , 
						'error'
					);	

				}else if(updateProfile.fname.match(this.namePattern) == null){
					this.$swal("ERROR", "Invalid character on First Name", "error");
				}else if(updateProfile.lname.match(this.namePattern) == null){
					this.$swal("ERROR", "Invalid character on Last Name", "error");
				}
				else {

					fetch(API + "/check/usernames/" + updateProfile.user_id)
					.then(data => {
						return data.json();
					})
					.then(json => {
						let usernameFound = false;
						let i = 0;

						for(i; i < json.length; i++){
							if(json[i].username == updateProfile.username){
								usernameFound = true;
							}
						}

						if (usernameFound) {
							this.$swal(
								'WARNING' , 
								'Username already exists , Please Try Again.' , 
								'warning'
							);

						} else { 

							fetch(API + '/update/profile/', { 
								method: 'post',
								headers: {
									'Content-Type': 'application/json'},
								body: JSON.stringify(updateProfile)
							}).then(data => {
								return data.json();
							}).then(json => {

								if (json.success === true) {

									this.$swal(
										'SUCCESS' , 
										'Profile updated successfully!' , 
										'success'
									);	
									this.getMyProfile();

								} else {
									this.$swal(
										'ERROR' , 
										'Something went wrong , Please try again.' , 
										'error'
									);	
								}

							});

						}

					});	



				}

			} ,

			changePass () {
				let changePass = {
					user_id        : token ,
					old_password   : this.old_password ,
					new_password   : this.new_password ,
					verify_password: this.verify_password ,
				};

				if (!changePass.old_password.trim() || !changePass.new_password.trim() || !changePass.verify_password.trim()) {
					this.$swal(
						'ERROR' , 
						'All fields are required' , 
						'error'
					);	
				} else {

					fetch(API + "/check/old_password/" + changePass.user_id + "/" + changePass.old_password)
					.then(data => {
						return data.json();
					})
					.then(json => {

						if (json.success === true) {

							if (changePass.new_password != changePass.verify_password) {

								this.$swal(
									'WARNING' , 
									'Verify password not match , Please try again.' , 
									'warning'
								);	

							} else {

								fetch(API + '/update/password/', { 
									method: 'post',
									headers: {
										'Content-Type': 'application/json'},
									body: JSON.stringify(changePass)
								}).then(data => {
									return data.json();
								}).then(json => {

									if (json.success === true) {

										this.$swal(
											'SUCCESS' , 
											'Password changed successfully!' , 
											'success'
										);	

										this.old_password = "";
										this.new_password = "";
										this.verify_password = "";

									} else {
										this.$swal(
											'ERROR' , 
											'Something went wrong , Please try again.' , 
											'error'
										);	
									}

								});
							}

						} else {
							this.$swal(
								'WARNING' , 
								'The old password not match , Please try again.' , 
								'warning'
							);	
						}

					});
				}
			} ,
		} ,

		beforeMount () {
			this.$emit('verify');
			this.getActiveColor();
			this.getMyProfile();
		} ,
	}	
</script>