<template>
	<v-container fluid>
		<v-btn
			:color="color"
			dark					
			class="mt-2"
			@click="add_email_dialog = !add_email_dialog"
			left>
			Add Email
		</v-btn>

		<v-dialog v-model="add_email_dialog" max-width="700px" persistent>
			<v-card>
				<v-card-title> Add Email </v-card-title>

				<v-card-text>
					<v-container>
						<v-row>
							<v-col cols="12">
								<v-text-field
									v-model="email"
									label="Email"
									:color="color">
								</v-text-field>
							</v-col>
						</v-row>
						<v-row
							justify="end">
							<v-btn color="primary" @click="addEmail"> Add </v-btn>
							<v-btn color="error" class="ml-2 mr-3" @click="add_email_dialog = !add_email_dialog"> Close </v-btn>
						</v-row>
					</v-container>
				</v-card-text>	
			</v-card>		
		</v-dialog>	

		<v-btn
			:color="color"
			dark					
			class="mt-2 ml-2"
			@click="set_email_time_dialog = !set_email_time_dialog">
			Set Email Time
		</v-btn>

		<v-btn
			:color="color"
			dark					
			class="mt-2 ml-2"
			@click="set_email_sender_dialog = !set_email_sender_dialog">
			Set Email Sender
		</v-btn>

		<v-row>
			<v-col cols="6">
				<v-text-field v-model="email_time" readonly filled :color="color" hide-details>	
					<v-icon slot="prepend-inner" :color="color">info</v-icon>
				</v-text-field>
			</v-col>
			<v-col cols="6">
				<v-text-field v-model="due_notif" readonly filled :color="color" hide-details>	
					<v-icon slot="prepend-inner" :color="color">info</v-icon>
				</v-text-field>
			</v-col>

			<v-col cols="12" sm="6">
				<v-text-field
					v-model="search1"
					label="Search Email"
					append-icon="search"
					hide-details
					:color="color">
				</v-text-field>
					
				<v-data-table
					:headers="headers_email"
					:items="emails"
					:search="search1"
					:loading="loading1"
					:loading-text="loading_text1"
					:items-per-page="10"
					class="mt-5 elevation-1">

					<template v-slot:item.created_date="{ item }">
						{{ item.created_date | moment("YYYY-MM-DD") }}
					</template>

					<template v-slot:item.action="{ item }">
						<v-tooltip bottom>
							<template v-slot:activator="{ on }">
								<span v-on="on">
									<v-chip @click="editEmail(item)" id="qchip3">
										<v-icon color="teal" small>edit</v-icon>
									</v-chip>
								</span>
							</template>

							<span> Edit Email </span>
						</v-tooltip>
						
						<v-tooltip bottom>
							<template v-slot:activator="{ on }">
								<span v-on="on">
									<v-chip @click="deleteEmailAdd(item)" class="ml-1" id="qchip3">
										<v-icon color="error" small>delete</v-icon>
									</v-chip>
								</span>
							</template>
							<span>Delete Email</span>
						</v-tooltip>
					</template>
				</v-data-table>
			</v-col>

			<v-col cols="12" sm="6">
				<v-data-table
					:headers="headers_color"
					:items="colors"
					:search="search2"
					:loading="loading2"
					:loading-text="loading_text2"
					:items-per-page="10"
					class="elevation-1">

					<template v-slot:item.color="{ item }">
						<v-chip dark :color="item.color">
							{{ item.color }}
						</v-chip>
					</template>

					<template v-slot:item.color_status="{ item }">
						<v-chip v-if="item.color_id === color_id_user" :color="item.color" dark>
							On
						</v-chip>
						<v-chip v-else>
							Off
						</v-chip>
					</template>

					<template v-slot:item.action="{ item }">
						<v-tooltip bottom>
							<template v-slot:activator="{ on }">
								<span v-on="on">
									<v-chip @click="activeColor(item)" id="qchip3">
										<v-icon :color="color" small>palette</v-icon>
									</v-chip>
								</span>
							</template>
							<span> Active This Color </span>
						</v-tooltip>
					</template>
					
					<v-tooltip bottom>
						<template v-slot:activator="{ on }">
							<span v-on="on">
								<v-chip @click="deleteEmailAdd(item)" class="ml-1" id="qchip3">
									<v-icon color="error" small>delete</v-icon>
								</v-chip>
							</span>
						</template>
						<span>Delete Email</span>
					</v-tooltip>
				</v-data-table>
			</v-col>
			
		</v-row>

		<v-dialog v-model="edit_email_dialog" max-width="700px" persistent>
			<v-card>
				<v-card-title> Edit Email </v-card-title>

				<v-card-text>
					<v-container>
						<v-row>
							<v-col cols="12">
								<v-input
									v-model="email_id"
									hideDetails>
								</v-input>

								<v-text-field
									v-model="edit_email"
									type="email"
									label="Email"
									:color="color">
								</v-text-field>
							</v-col>
						</v-row>
						<v-row
							justify="end">
							<v-btn color="primary" @click="updateEmail"> Update </v-btn>
							<v-btn color="error" class="ml-2 mr-3" @click="edit_email_dialog = !edit_email_dialog"> Close </v-btn>
						</v-row>
					</v-container>
				</v-card-text>	
			</v-card>
		</v-dialog>

		<v-dialog v-model="set_email_time_dialog" max-width="700px" persistent>
			<v-card>
				<v-card-title> Set Email Time (24 Hour Format) </v-card-title>

				<v-card-text>
					<v-container>
						<v-row>
							<v-col cols="6">
								<v-text-field
									v-model="time_hour"
									type="number"
									label="Hour"
									:color="color"
									max="24" min="1">
								</v-text-field>
							</v-col>
							<v-col cols="6">
								<v-text-field
									v-model="time_minute"
									type="number"
									label="Minute"
									:color="color"
									max="59" min="0">
								</v-text-field>
							</v-col>
						</v-row>

						<v-row
							justify="end">
							<v-btn color="primary" @click="setEmailTime"> SAVE TIME </v-btn>
							<v-btn color="error" class="ml-2 mr-3" @click="set_email_time_dialog = !set_email_time_dialog"> Close </v-btn>
						</v-row>
					</v-container>
				</v-card-text>	

			</v-card>		
		</v-dialog>

		<v-dialog v-model="set_email_sender_dialog" max-width="700px" persistent>
			<v-card>
				<v-card-title> Set Email Sender </v-card-title>

				<v-card-text>
					<v-container>
						<v-row>
							<v-col cols="12">
								<v-text-field v-model="email_sender" readonly filled :color="color" hide-details>	
									<v-icon slot="prepend-inner" :color="color">info</v-icon>
								</v-text-field>
							</v-col>
							<v-col cols="12">
								<v-input
									v-model="email_sender_id"
									hideDetails>
								</v-input>

								<v-text-field
									v-model="set_email_sender"
									type="email"
									label="Email"
									:color="color"
									hide-details>
								</v-text-field>
							</v-col>
							<v-col cols="6">
								<v-text-field
									v-model="set_email_sender_password"
									:append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
									:type="show1 ? 'text' : 'password'"
									@click:append="show1 = !show1"
									label="Password"
									:color="color">
								</v-text-field>
							</v-col>
							<v-col cols="6">
								<v-text-field
									v-model="verify_email_sender_password"
									:append-icon="show2 ? 'mdi-eye' : 'mdi-eye-off'"
									:type="show2 ? 'text' : 'password'"
									@click:append="show2 = !show2"
									label="Verify Password"
									:color="color">
								</v-text-field>
							</v-col>
						</v-row>
						<v-row
							justify="end">
							<v-btn color="primary" @click="setEmailSender"> SET EMAIL </v-btn>
							<v-btn color="error" class="ml-2 mr-3" @click="set_email_sender_dialog = !set_email_sender_dialog"> Close </v-btn>
						</v-row>
					</v-container>
				</v-card-text>	
			</v-card>		
		</v-dialog>
	</v-container>
</template>

<script>
	import { API , token } from "../main"

	export default {
		data () {
			return {
				add_email_dialog: false ,
				edit_email_dialog: false ,
				panel: [ 0 , ] ,
				set_email_time_dialog: false,
				set_email_sender_dialog: false,
				show1: false,
				show2: false,
				
				switch1: true ,
				dark: false ,

				email_id: null ,
				email: "" ,
				
				edit_email: "" ,

				email_sender_id: "",
				email_sender: "The current email address of sender is: ",
				set_email_sender: "",
				set_email_sender_password: "",
				verify_email_sender_password: "",

				search1: "" ,
				search2: "" ,
				loading1: true ,
				loading2: true ,
				loading_text1: "Loading Emails ... Please Wait" ,
				loading_text2: "Loading Colors ... Please Wait" ,

				emails: [] ,
				colors: [] ,
				background: [] ,
				headers_email: [
					{
						text: "Email Recievers" ,
						value: "email"
					} ,
					{
						text: "Created Date" ,
						value: "created_date" ,
						align: "center" ,
					} ,
					{
						text: "Actions" ,
						value: "action" ,
						sortable: false ,
						align: "center" ,	
					}
				] ,

				headers_color: [
					{
						text: "Color" ,
						value: "color" ,
					} ,
					{
						text: "Status" ,
						value: "color_status" ,
					} , 
					{
						text: "Actions" ,
						value: "action" ,
					}
				] ,

				headers_dark: [
					{
						text: "Color" ,
						value: "dark"
					} ,
					{
						text: "Status" ,
						value: "status" ,
					} ,
					{
						text: "Actions" ,
						value: "action"
					}
				] ,
				time_hour: 0,
				time_minute: 0,

				email_time: "The email was set to send every ",
				due_notif: "Notification of due billings was show every hour",
				color_id_user: "" ,
				color: null ,
			}
		} ,

		methods: {

			addEmail () {
				let email = this.email;
				let emailFound = false;
				let countExceed = false;

				fetch(API + '/count/email')
				.then(response => response.json())
				.then(data => {
					if(data[0].count_email > 10){
						countExceed = true;
					}
					if(countExceed){
						this.$swal("ERROR", "You are allowed to add another email address, the maximum email address is 10", "error");
					}else if(!countExceed){
						if (!email) {

							this.$swal(
								'ERROR' ,
								'Email field is required!' ,
								'error'
							);

						}else if(email.includes("@") == false || email.includes(".com") == false){
							this.$swal("ERROR", "Invalid email address", "error");
						} else {

							fetch(API + '/add/get/emails')
							.then(response => response.json())
							.then(data =>{
								for(var a = 0; a < data.length; a++){
									if(data[a].email === email){
										emailFound = true;
									}
								}

								if(emailFound){
									this.$swal("ERROR","Email address is already use", "error");
								}else{

									fetch(API + '/add/new/email/', {
										method: 'post',
										headers: {
												'Content-Type': 'application/json'},
										body: JSON.stringify({ email: email })
									}).then( data => {
										return data.json();
									})
									.then(json => {
										if (json.success === true) {

											this.$swal(
												'SUCCESS' , 
												'Email Added Successfully!' , 
												'success'
											);

											this.loading = true;
											this.add_email_dialog = false;
											this.email = "";
											this.getEmails();


										} else if (json.success === false ) {
											
											this.$swal(
												'WARNING' , 
												'Sorry Email Already Exists , Try Another Email' , 
												'warning'
											);

										} else {

											this.$swal(
												'ERROR' , 
												'Something Went Wrong , Please Try Again .' , 
												'error'
											);

										}
									});
								}
							});

						}
					}
				});

			} ,

			updateEmail () {
				let updateEmail = {
					email_id: this.email_id ,
					email 	: this.edit_email
				}
				let emailFound = false;
				fetch(API + '/get/email/by/' + updateEmail.email_id)
				.then(response => response.json())
				.then(data =>{
					for(var a = 0; a < data.length; a++){
						if(data[a].email == updateEmail.email){
							emailFound = true;
						}
					}

					if(emailFound){
						this.$swal("ERROR", "Email is already use", "error");
					}else if(updateEmail.email.includes("@") == false || updateEmail.email.includes(".com") == false){
						this.$swal("ERROR", "Invalid email address", "error");
					}else{
						fetch(API + '/update/email/', {
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify(updateEmail)
						}).then( data => {
							return data.json();
						})
						.then(json => {
							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'Email Updated Successfully!' , 
									'success'
								);

								this.loading = true;
								this.edit_email_dialog = false;
								this.getEmails();


							} else {

								this.$swal(
									'ERROR' , 
									'Something Went Wrong , Please Try Again .' , 
									'error'
								);

							}
						});
					}
				});

			} ,

			editEmail (item) {
				this.edit_email_dialog = true;
				this.email_id   = item.email_id;
				this.edit_email = item.email;
			} ,


			deleteEmailAdd(item) {
				let deleteEmail = true;

				fetch(API + '/get/emails/')
				.then(response => response.json())
				.then(data => {
					if(data.length == 1){
						deleteEmail = false;
					}

					if(!deleteEmail){
						this.$swal("ERROR", "This is the last email address, you are not allowed to delete it", "error");
					}else if(deleteEmail){
						this.$swal({
							title: 'Are you sure?',
							text: "You want to delete this bill",
							icon: 'warning',
							showCancelButton: true,
							confirmButtonColor: '#3085d6',
							cancelButtonColor: '#d33',
							confirmButtonText: 'Yes, delete it!'

						}).then((result) => {
							if (result.value) {
								fetch(API + '/delete/email/',{
									method: "post",
									headers: {
										'Content-Type': 'application/json'
									},
									body: JSON.stringify({email_id: item.email_id})
								}).then(response => response.json())
								.then(data => {
									if(data.success == true){
										this.$swal("SUCCESS", "Email address is Successfully deleted", "success");
										this.getEmails();
									}else{
										this.$swal("ERROR", "Delete failed", "error");
									}
								});
							}
						});
					}
				});
			} ,

			activeColor (item) {
				let activeColor = {
					color_id: item.color_id ,
					user_id : token ,
				}

				fetch(API + '/check/colors/' + activeColor.color_id + "/" + activeColor.user_id)
				.then(data => {
					return data.json();
				}).then(json => {

					if (json.success === true) {

						fetch(API + '/update/colors/', {
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify(activeColor)
						}).then( data => {
							return data.json();
						})
						.then(json => {

							if (json.success === true) {

								this.getColors();
								this.getActiveColor();
								this.$emit("getActiveColor");

							} else {
								this.$swal(
									'ERROR' , 
									'Something Went Wrong , Please Try Again .' , 
									'error'
								);

							}

						});

					} else {

						this.$swal(
							'ERROR' , 
							'This is Already the Theme.' , 
							'error'
						);

					}

				});
			
			} ,
 
			getEmails () {
				fetch(API + '/get/emails/')
				.then(response => response.json())
				.then(data => {
					this.emails   = data;
					this.loading1 = false;
				});
			} ,

			getColors () {
				fetch(API + '/get/colors/')
				.then(response => response.json())
				.then(data => {

					this.colors   = data;
					this.loading2 = false;
				});
			} ,

			setEmailTime(){
				if(!this.time_hour){
					this.$swal("ERROR", "All fields are required", "error");
				}else if(this.time_hour > 24 || this.time_hour < 1){
					this.$swal("ERROR", "Invalid hour format", "error");
				}else if(this.time_minute > 59 || this.time_minute < 0){
					this.$swal("ERROR", "Invalid minute format", "error");
				}else{
					fetch(API + '/set/email/time/',{
						method: 'post',
						headers: {
							'Content-Type': 'application/json' 
						},
						body: JSON.stringify({
							set_hour: this.time_hour,
							set_min: this.time_minute
						})
					}).then(response => response.json())
					.then(data => {
						if(data.success == true){
							if(this.time_minute < 10){
								this.time_minute = "0" + this.time_minute;
							}
							this.$swal("SUCCESS", this.time_hour + ":" + this.time_minute + " email time was saved successfully", "success");
							this.email_time = "The email was set to send every ";
							this.getSetTime();
							this.time_hour = 0;
							this.time_minute = 0;
							this.set_email_time_dialog = false;
						}else{
							this.$swal("ERROR", "Set time failed, there is no sender email address", "error");
						}
					});
				}
			},

			getSetTime(){
				fetch(API + '/get/set/time/')
				.then(response => response.json())
				.then(data => {
					let hour = data[0].email_time_hour;
					let min = data[0].email_time_minute;
					let apm = "am";
					let time = "am";
					if(hour > 11 && hour < 24)
						{ apm = "pm";}
					if(hour > 12){
						hour -= 12;
						if(hour < 10)
							{ hour = "0" + hour; }
						if(min < 10)
							{ min = "0" + min; }
						time = "(" + hour + ":" + min + " " +  apm + ")";
					}
					if( data[0].email_time_hour == 12)
						{ time = "pm"; }
					if(data[0].email_time_hour < 10)
						{ data[0].email_time_hour = "0" + data[0].email_time_hour; }
					if(data[0].email_time_minute < 10)
						{ data[0].email_time_minute = "0" + data[0].email_time_minute; }

					this.email_time += data[0].email_time_hour + ":" + data[0].email_time_minute + " " + time + " everyday";
				});
			} ,

			getActiveColor () {
				fetch(API + '/get/active/color/' + token)
				.then(response => response.json())
				.then(data => {
					this.color         = data[0].color;
					this.color_id_user = data[0].color_id;
				});
			} ,

			getEmailSender(){
				fetch(API + '/get/email/sender/')
				.then(response => response.json())
				.then(data => {
					if(data.length > 0){
						this.email_sender_id = data[0].email_id;
						this.email_sender += data[0].email;
					}else if (data.length == 0){
						this.email_sender = "There is no current email address for sender";
					}
				});
			},

			setEmailSender(){
				if(!this.set_email_sender.trim() || !this.set_email_sender_password.trim() || !this.verify_email_sender_password.trim()){
					this.$swal("ERROR", "All fields are required", "error");
				}else if(this.set_email_sender.includes("@") == false || this.set_email_sender.includes(".com") == false){
					this.$swal("ERROR", "Invalid email address", "error");
				}else if(this.set_email_sender_password != this.verify_email_sender_password){
					this.$swal("ERROR", "Verify password did not match", "error");
				}
				else{
					fetch(API + '/check/set/email/' + this.set_email_sender)
					.then(response => response.json())
					.then(data =>{
						if(data.length > 0){
							if(data[0].status == 2){
								this.$swal("ERROR", "Email address is already use as sender", "error");
							}else{
								this.$swal("ERROR", "Email address is already use as one of the receivers", "error");
							}
						}else{
							fetch(API + '/set/email/sender/',{
								method: "post",
								headers: {
									"Content-Type": "application/json"
								},
								body: JSON.stringify({
									email_id: this.email_sender_id,
									email_sender: this.set_email_sender,
									email_pass: this.set_email_sender_password
								})
							}).then(response => response.json())
							.then(data =>{
								if(data.success == true){
									this.$swal("SUCCESS", "The new email sender was set", "success");
									this.getEmailSender();
									this.email_sender = "The current email address of sender is: ";
									this.set_email_sender = "";
									this.set_email_sender_password = "";
									this.set_email_sender_dialog = false;
								}else{
									this.$swal("ERROR", "Set email failed", "error");
								}
							});
						}
					});
				}
			},
		} ,

		beforeMount () {
			this.$emit('verify');
			this.getActiveColor();
			this.getEmails();
			this.getColors();
			this.getSetTime();
			this.getEmailSender();
		}
	}	
</script>

<style lang="scss">
	#color41{
		background-color: #D32F2F;
	}

	#color41{
		background-color: #D32F2F;
	}

	#color41{
		background-color: #D32F2F;
	}

	#color41{
		background-color: #D32F2F;
	}
</style>