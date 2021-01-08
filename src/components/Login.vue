<template>
	<v-layout fill-height align-center justify-center>
		<v-flex id="login_from" class="text-center">
			<v-card>
				<v-card-text>
					<div class="mt-5 mb-3 subheading">
						<h1> LOGIN </h1>
					</div>

					<v-text-field v-model="username" light prepend-icon="person" label="Username" color="orange darken-2"></v-text-field>
					<v-text-field 
						v-model="password"
						light
						prepend-icon="lock" 
						label="Password"
						:append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
						:type="show1 ? 'text' : 'password'"
						@click:append="show1 = !show1"
						color="orange darken-2">
					</v-text-field>

					<v-btn type="submit" color="orange darken-2" class="mt-3 mb-5" dark @click="login"> Sign in </v-btn>
				</v-card-text>
			</v-card>
		</v-flex>
	</v-layout>
</template>

<script>
	import { API , token } from '../main'
	import auth from '../auth'

	export default {
		data () {
			return {
				username: '' ,
				password: '' ,
				show1   : false ,
			}
		} , 

		mounted () {
			this.verify();
		},

		methods: {
			verify () {
                auth.checkAuth(token);
            } ,

			login (e) {
				e.preventDefault();

				let newLogin = {
					username: this.username ,
					password: this.password ,
				};

				if (!newLogin.username && !newLogin.password) {
					this.$swal(
						'Error!',
						'All fields Are Required!' ,
						'error'
					);
				} else if (!newLogin.username || !newLogin.password) {
					this.$swal(
                        'Warning!',
                        'Please all field are required!' ,
                        'warning'
                    );
				} else {

					fetch(API + "/login" , {
						method: "POST" ,
						headers: {
							"content-type": "application/json"
						} ,
						body: JSON.stringify(newLogin)

					}).then(data => {

						return data.json();

					}).then(json => {

						if (json.success === true) {

							window.localStorage.setItem('__TokenName' , json.name);
							window.localStorage.setItem('__TokenId' , json.token);
							window.location.reload();

						} else if (json.success === false) {

							this.$swal(
								'Error!',
								'Username or Password not match!' ,
								'error'
							); 


						} else {

							this.$swal(
								'Error!',
								'Something Went Wrong2! , Please Try Again.' ,
								'error'
							);

						}
					});

				}

			}
		} ,

		
	}
</script>

<style lang="scss">
	$primary: #222;
    $secondary: #555;
    $s1: #ed7719;
    $s2: #3e2c05;
    $s3: #201500;

	#app1 {
		//Two
		background: rgb(117,29,29);
        background: linear-gradient(0deg, rgba(117,29,29,1) 0%, rgba(255,169,86,1) 100%);
		//Three
		//background: rgb(237,119,25);
        //background: linear-gradient(90deg, rgba(237,119,25,1) 0%, rgba(62,44,5,1) 52%, rgba(32,21,0,1) 100%);
	}
	#login_from {
		max-width: 470px;

		h4 , v-icon {
			color: #fff;
		}
	}
</style>