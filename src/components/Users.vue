<template>
	<v-container fluid>
		<v-btn
			:color="color"
			dark					
			class="mt-2"
			@click="users_dialog = !users_dialog">
			New User
		</v-btn>

		<v-dialog v-model="users_dialog" max-width="700px" persistent>
			<v-card>
				<v-card-title> New User </v-card-title>

				<v-card-text>
					<v-container>
						<v-row>
							<v-col cols="12" sm="6">
								<v-text-field
									v-model="fname"
									type="text"
									label="First Name"
									:color="color">
								</v-text-field>

								<v-text-field
									v-model="username"
									type="text"
									label="Username"
									:color="color">
								</v-text-field>
							</v-col>
							<v-col cols="12" sm="6">
								<v-text-field
									v-model="lname"
									label="Last Name"
									type="text"
									:color="color">
								</v-text-field>

								<v-text-field
									v-model="password"
									type="password"
									label="Password"
									:color="color">
								</v-text-field>
							</v-col>
						</v-row>
						<v-row
							justify="end">
							<v-btn color="primary" @click="addUser"> Add </v-btn>
							<v-btn color="error" class="ml-2 mr-3" @click="users_dialog = !users_dialog"> Close </v-btn>
						</v-row>
					</v-container>
				</v-card-text>
			</v-card>
		</v-dialog>
		
		<template v-if="users.length === 0">
		</template>

		<template v-else>
			<v-text-field
				v-model="search"
				label="Search Billing"
				append-icon="search"
				class="mt-3"
				hide-details
				:color="color">
			</v-text-field>
		</template>		

		<v-data-table
			:headers="headers_users"
			:items="users"
			:search="search"
			:loading="loading"
			:loading-text="loading_text"
			:items-per-page="10"
			class="mt-5 elevation-1">

			<template v-slot:item.name="{ item }">
				{{ item.fname }} {{ item.lname }}
			</template>

			<template v-slot:item.date_created="{ item }">
				{{ item.date_created | moment("YYYY-MM-DD") }}
			</template>
			
			<template v-slot:item.date_modified="{ item }">
				{{ item.date_modified | moment("YYYY-MM-DD") }}
			</template>

			<template v-slot:item.status="{ item }">
				<v-chip
					v-if="item.status === 0">
					Not Active
				</v-chip>
				<v-chip v-else>
					Active
				</v-chip>
			</template>
			
			<template 
				v-slot:item.action="{ item }">
				<v-tooltip bottom>
					<template v-slot:activator="{ on }">
						<span v-on="on">
							<v-chip @click="editUser(item)" class="ml-1" id="qchip3">
								<v-icon color="primary" small> edit</v-icon>
							</v-chip>
						</span>
						
					</template>
					<span> Edit </span>
				</v-tooltip>
				
				<v-tooltip bottom>
					<template v-slot:activator="{ on }">
						<span v-on="on">
							<v-chip @click="deleteUser(item)" class="ml-1" id="qchip3">
								<v-icon color="error" small> delete</v-icon>
							</v-chip>
						</span>
					</template>
					<span> Delete </span>
				</v-tooltip>
			</template>

		</v-data-table>

		<v-dialog v-model="edit_dialog" max-width="700px" persistent>
			<v-card>
				<v-card-title> Edit User </v-card-title>

				<v-card-text>
					<v-container>
						<v-input
							v-model="edit_user_id"
							hideDetails>
						</v-input>
						<v-row>
							<v-col cols="12" sm="4">
								<v-text-field
									v-model="edit_fname"
									type="text"
									label="First Name"
									:color="color">
								</v-text-field>

							</v-col>
							<v-col cols="12" sm="4">
								<v-text-field
									v-model="edit_lname"
									label="Last Name"
									:color="color">
								</v-text-field>
							</v-col>
							<v-col cols="12" sm="4">
								<v-text-field
									v-model="edit_username"
									type="text"
									label="Username"
									:color="color">
								</v-text-field>
							</v-col>

							<v-col cols="12">
								<v-text-field
									v-model="new_password"
									label="New Password"
									:append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
									:type="show1 ? 'text' : 'password'"
									@click:append="show1 = !show1"
									:color="color">
								</v-text-field>
							</v-col>
						</v-row>
						<v-row
							justify="end">
							<v-btn color="primary" @click="updateUser"> Update </v-btn>
							<v-btn color="error" class="ml-2 mr-3" @click="edit_dialog = !edit_dialog"> Close </v-btn>
						</v-row>
					</v-container>
				</v-card-text>
			</v-card>
		</v-dialog>			
	</v-container>
</template>

<script>
	import { API , token } from '../main'

	export default {
		data () {
			return {
				users_dialog: false ,
				edit_dialog: false ,
				fname: "" ,
				lname: "" ,
				username: "" ,
				password: "" ,
				token: token ,

				edit_user_id: "" ,
				edit_fname: "" ,
				edit_lname: "" ,
				edit_username: "" ,
				new_password: "" ,
				show1: false ,

				users: [] ,
				search: "" ,

				loading: true ,
				loading_text: "Loading Users ... Please Wait" ,
				headers_users: [ 
					{
						text: "Name" ,
						value: "name" ,
					} ,
					{
						text: "Username" ,
						value: "username" ,
					} ,  
					{
						text: "Date Created" ,
						value: "date_created" ,
					} , 
					{
						text: "Date Modified" ,
						value: "date_modified" ,
					} ,
					{
						text: "Status" ,
						value: "status" ,
					} ,
					{
						text: "Actions" ,
						value: "action" ,
						align: "center" ,
						sortable: false ,
					} ,
				] ,
				color: null ,
				namePattern: /^[A-Za-z -.]*$/ ,
			}
		} , 

		methods: {
			verifyAdmin () {
				fetch(API + '/get/admin/' + token)
				.then(response => response.json())
				.then(data => {
					if (data.length === 0) {
						window.location.href = "/login";
					}
				});
			} ,

			addUser () {
				let addUser = {
					fname: this.fname ,
					lname: this.lname ,
					username: this.username ,
					password: this.password ,
				};

				if (!addUser.fname.trim() || !addUser.lname.trim() || !addUser.username.trim() || !addUser.password.trim()) {

					this.$swal(
						'ERROR' , 
						'All fields are required' , 
						'error'
					);

				} else {

					if(addUser.fname.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on First Name", "error");
					}else if(addUser.lname.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Last Name", "error");
					}else{
						fetch(API + '/add/user/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify(addUser)
						}).then(data => {
							return data.json();
						}).then(json => {

							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'User Added Successfully!' , 
									'success'
								);

								this.fname = "";
								this.lname = "";
								this.username = "";
								this.password = "";
								this.getUsers();
								this.users_dialog = false;

							} else if (json.success === false) {

								this.$swal(
									'WARNING' , 
									'Username already exists , Please Try Again.' , 
									'warning'
								);

							} else {

								this.$swal(
									'ERROR' , 
									'Something went wrong! Please try again.' , 
									'error'
								);

							}
						});
					}

				}				
			} ,

			editUser (item) {
				this.edit_dialog   = true;
				this.edit_user_id  = item.user_id;
				this.edit_fname    = item.fname;
				this.edit_lname    = item.lname;
				this.edit_username = item.username;
			} ,

			updateUser () {

				let updateUser = {
					user_id 	: this.edit_user_id ,
					fname   	: this.edit_fname ,
					lname   	: this.edit_lname , 
					username    : this.edit_username ,
					new_password: this.new_password ,
				};

				if (!updateUser.fname.trim() || !updateUser.lname.trim() || !updateUser.username.trim() || !updateUser.new_password.trim()) {
					
					this.$swal(
						'ERROR' , 
						'All fields are required' , 
						'error'
					);	

				} else {

					if(updateUser.fname.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on First Name", "error");
					}else if(updateUser.lname.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Last Name", "error");
					}else{

						fetch(API + "/check/usernames/" + updateUser.user_id)
						.then(data => {
							return data.json();
						})
						.then(json => {
							let usernameFound = false;
							let i = 0;

							for(i; i < json.length; i++){
								if(json[i].username == updateUser.username){
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
								fetch(API + '/update/user/', { 
									method: 'post',
									headers: {
											'Content-Type': 'application/json'},
									body: JSON.stringify(updateUser)
								}).then(data => {
									return data.json();
								}).then(json => {

									if (json.success === true) {

										this.$swal(
											'SUCCESS' , 
											'User Updated Successfully!' , 
											'success'
										);

										this.getUsers();
										this.edit_dialog = false;
										this.new_password = "";

									} else {

										this.$swal(
											'ERROR' , 
											'Something went wrong! Please try again.' , 
											'error'
										);

									}
								});

							}
						});

					}			

				}

			} ,

			deleteUser (item) {

				let user_id = item.user_id;

				this.$swal({
					title: 'Are you sure?',
					text: "You want to delete this user",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes, delete it!'
				}).then((result) => {
					if (result.value) {
						fetch(API + '/delete/user/',{
							method: 'post',
							headers:{
								'Content-Type': 'application/json'
							},
							body: JSON.stringify({ user_id : user_id })
						}).then( data => {
							return data.json();
						})
						.then(json =>{
							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'User Deleted Successfully!' , 
									'success'
								);

								this.getUsers();

							} else {
								this.$swal(
									'ERROR' , 
									'Something went wrong! Please try again.' , 
									'error'
								);
							}
						});
					}
				});	
			} ,

			getUsers () {
				fetch(API + "/get/users/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.users   = json;
                    this.loading = false;
                });
			} ,

			getActiveColor () {
				fetch(API + '/get/active/color/' + token)
				.then(response => response.json())
				.then(data => {
					this.color = data[0].color;
				});
			} ,
		} ,

		beforeMount () {
			this.$emit('verify');
			this.verifyAdmin();
			this.getActiveColor();
			this.getUsers();
		} ,
	}
</script>