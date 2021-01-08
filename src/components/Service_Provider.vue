<template>
	<v-container fluid>
		<v-btn
			:color="color"
			dark
			class="mt-2"
			@click="add_service_dialog = !add_service_dialog">
			New Service Provider
		</v-btn>

		<v-dialog v-model="add_service_dialog" max-width="700px" persistent>
			<v-card>
				<v-card-title> New Service Provider </v-card-title>

				<v-card-text>
					<v-container>
						<v-row>
							<v-col cols="12">
								<v-text-field
									v-model="service_provider"
									label="Service Provider"
									:color="color">
								</v-text-field>
							</v-col>
							<v-col cols="12">
								<v-text-field
									v-model="created_by"
									label="Created By" readonly
									:color="color">
								</v-text-field>
							</v-col>
						</v-row>
					</v-container>			
				</v-card-text>	

				<v-card-subtitle>
					<v-row
						align="center"
						justify="end">
						<v-btn color="primary" @click="addServiceProvider"> Add </v-btn>
						<v-btn color="error" class="ml-2 mr-5" @click="add_service_dialog = !add_service_dialog"> Close </v-btn>
					</v-row>
				</v-card-subtitle>
			</v-card>	
		</v-dialog>	

		<v-text-field
			v-model="search"
			label="Search Service Provider"
			append-icon="search"
			class="mt-3"
			hide-details
			:color="color">
		</v-text-field>

		<v-data-table
			:headers="headers_service_provider"
			:items="service_providers"
			:search="search"
			:loading="loading"
			:loading-text="loading_text"
			:items-per-page="10"
			class="mt-5 elevation-1">

			<template v-slot:item.date_created="{ item }">
				{{ item.date_created | moment('MM-DD-YYYY') }}
			</template>

			<template v-slot:item.created_by="{ item }">
				{{ item.created_by }}
			</template>

			<template v-slot:item.action="{ item }">
				<v-tooltip left>
					<template v-slot:activator="{ on }">
						<span v-on="on">
							<v-chip
								@click="editServiceProvider(item)"
								id="qchip3">
								<v-icon
									color="primary"
									small>
									edit
								</v-icon>
							</v-chip>
						</span>
					</template>
					<span> Edit Service Provider </span>
				</v-tooltip>

				<v-tooltip left>
					<template v-slot:activator="{ on }">
						<span v-on="on">
							<v-chip
								@click="deleteServiceProvider(item)"
								id="qchip3"
								class="ml-1">
								<v-icon
									color="error"
									small>
									delete
								</v-icon>
							</v-chip>
						</span>
					</template>
					<span> Delete Service Provider </span>
				</v-tooltip>
			</template>
		</v-data-table>

		<v-dialog v-model="edit_service_dialog" max-width="700px" persistent>
			<v-card>
				<v-card-title> Edit Service Provider </v-card-title>

				<v-card-text>
					<v-container>
						<v-row>
							<v-col cols="12">
								<v-input
									v-model="edit_service_id"
									hideDetails>
								</v-input>

								<v-text-field
									v-model="edit_service_provider"
									label="Service Provider"
									:color="color">
								</v-text-field>

								<v-text-field
									v-model="edit_created_by" readonly
									label="Service Provider"
									:color="color">
								</v-text-field>
							</v-col>
						</v-row>
					</v-container>			
				</v-card-text>	

				<v-card-subtitle>
					<v-row
						align="center"
						justify="end">
						<v-btn color="primary" @click="updateServiceProvider"> Update </v-btn>
						<v-btn color="error" class="ml-2 mr-5" @click="edit_service_dialog = !edit_service_dialog"> Close </v-btn>
					</v-row>
				</v-card-subtitle>
			</v-card>	
		</v-dialog>	
	</v-container>
</template>

<script>
	import { API , token , tokenName } from '../main'

	export default {
		data () {
			return {
				add_service_dialog: false ,
				service_provider: "" ,
				created_by: tokenName ,
				search: "" ,
				loading: true ,
				loading_text: "Loading .... Service Providers Please Wait ..." ,
				service_providers: [] ,
				headers_service_provider: [
					{
						text: "Service Provider" ,
						value: "name" ,
						align: "left" ,
					} ,
					{
						text: "Date Created" ,
						value: "date_created" ,
					} ,
					{
						text: "Created By" ,
						value: "created_by" ,
					} ,
					{
						text: "Actions" ,
						value: 'action' , 
						align: "center" ,
						sortable: false ,
					} ,
				] ,

				/* Edit */
				edit_service_dialog: false ,
				edit_service_id: "" ,
				edit_service_provider: "" ,
				edit_created_by: tokenName ,

				stringPattern: /^[A-Za-z0-9 .-]*$/ ,
				color: null ,
				switch1: true ,
				dark: false ,
			}
		} ,

		methods: {
			
			addServiceProvider () {
				let name       = this.service_provider;
				let created_by = this.created_by;

				if (!name.trim()) {
					
					this.$swal(
						'ERROR' , 
						'Service Provider field is required!' , 
						'error'
					);

				} else {
					if(name.match(this.stringPattern) == null){
						this.$swal(
							'ERROR', 
							'Invalid character on Service Provider', 
							'error'
						);
					} else {
						let nameFound = false;
						fetch(API + '/find/service_provider/')
						.then(response => response.json())
						.then(data => {
							let status = 0;
							for(var i = 0; i < data.length; i++){
								if(data[i].name == name){
									nameFound = true;
									status = data[i].status;
								}
							}

							if(nameFound){
								if(status == 1){
									this.$swal("ERROR", "Service Provider is already use", "error");
								}else{
									this.$swal("ERROR", "Service Provider is already use by service provider located on trash", "error");
								}
							}else{	
								fetch(API + '/add/new/service_provider/', { 
									method: 'post',
									headers: {
											'Content-Type': 'application/json'},
									body: JSON.stringify({ name: name, created_by: created_by })
								}).then(data => {
							
									return data.json(); 
							
								}).then(json => { 

									if (json.success === true) {

										this.$swal(
											'SUCCESS' , 
											'Service Provider Addded Successfully!' , 
											'success'
										);

										this.service_provider   = "";
										this.add_service_dialog = false;
										this.getServiceProviders();

									} else if (json.success === false) {

										this.$swal(
											'WARNING' , 
											'Service Provider Already Exists!' , 
											'warning'
										);

									} else {

										this.$swal(
											'ERROR' , 
											'Something went wrong , Please Try Again.' , 
											'error'
										);

									}

								});
							}
						});

					}
				} 
			} ,

			editServiceProvider(item) {
				this.edit_service_id       = item.service_id;
				this.edit_service_provider = item.name;
				this.edit_service_dialog   = true;
			} ,


			updateServiceProvider() {
				let updateServiceProvider = {
					service_id: this.edit_service_id ,
					name      : this.edit_service_provider.trim() ,
					created_by: this.created_by,
				}

				if (!updateServiceProvider.name) {
					this.$swal(
						'ERROR' , 
						'Service Provider field is required!' , 
						'error'
					);
				} else {

					if(updateServiceProvider.name.match(this.stringPattern) == null){
						this.$swal(
							'ERROR', 
							'Invalid character on Service Provider', 
							'error'
						);
					} else {

						let nameFound = false;
						let i = 0;

						fetch(API + '/check/service_provider/' + updateServiceProvider.service_id)
						.then(data => {
							return data.json();
						})
						.then(json => {
							let status = 0;
							for(i; i < json.length; i++){
								if(json[i].name == updateServiceProvider.name){
									nameFound = true;
									status = json[i].status;
								}
							}

							if(nameFound){
								if(status == 1){
									this.$swal(
										'WARNING' , 
										'Service Provider is already use!' , 
										'warning'
									);
								}else{
									this.$swal('WARNING', 'Service Provider is already use by service provider located on trash', 'warning');
								}
						
							} else {

								fetch(API + '/update/service_provider/', { 
									method: 'post',
									headers: {
											'Content-Type': 'application/json'},
									body: JSON.stringify(updateServiceProvider)
								}).then(data => {
							
									return data.json(); 
							
								}).then(json => { 

									if (json.success === true) {

										this.$swal(
											'SUCCESS' , 
											'Service Provider Addded Successfully!' , 
											'success'
										);

										this.edit_service_provider = "";
										this.edit_service_dialog   = false;
										this.getServiceProviders();

									} else {

										this.$swal(
											'ERROR' , 
											'Something went wrong , Please Try Again.' , 
											'error'
										);

									}

								});


							}

                        });	
                    }    
				}
			} ,

			deleteServiceProvider (item) {

				this.$swal({
					title: 'Are you sure?',
					text: "You want to delete this Service provider",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes, delete it!'
				}).then((result) => {
					if (result.value) {
						fetch(API + '/delete/service_provider/',{
							method: 'post',
							headers:{
								'Content-Type': 'application/json'
							},
							body: JSON.stringify({ id : item.id})
						}).then( data => {
							return data.json()
						}).then(json =>{
							if(json.success === true){
								
								this.$swal(
									'SUCCESS' , 
									'Service Provider deleted successfully!' ,
									'success');
								this.getServiceProviders();

							}else{
								this.$swal('ERROR', 'Something went wrong , Please try again!', 'error');
							}
						});
					}
				});

			} ,

			getServiceProviders () {
				fetch(API + "/get/service_provider/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.service_providers = json;
                    this.loading           = false ;
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
			this.getActiveColor();
			this.getServiceProviders();
		} ,
	}
</script>