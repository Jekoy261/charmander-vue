<template>
	<v-container fluid>
		<v-btn
			:color="color"
			dark
			class="mt-2"
			@click="bill_dialog = !bill_dialog">
			New Bill
		</v-btn>
		
		<v-dialog v-model="bill_dialog" max-width="700px" persistent>
			<v-card>
				<v-card-title> New Bill </v-card-title>
				<v-card-text>
					<v-container>
						<v-row>
							<v-col cols="12">
								<template
									v-if="service_providers.length === 0">
									<v-combobox
										disabled
										label="Please add a Service Provider first">
									</v-combobox>
								</template>

								<template
									v-else>
									<v-combobox
										v-model="service_provider"
										:items="service_providers"
										item-text="name"
										item-value="name"
										label="Service Provider"
										:color="color"
										item-color="orange darken-2">
									</v-combobox>
								</template>

								<v-text-field type="text" v-model="account_name" label="Account Name" :color="color"></v-text-field>
								<v-text-field type="text" v-model="account_number" label="Account Number" :color="color" maxlength="20"></v-text-field>
								<v-text-field type="text" v-model="tel_no" label="Tel No / Service ID No" :color="color" maxlength="20"></v-text-field>
								<v-text-field type="text" v-model="created_by" readonly label="Created By" :color="color"></v-text-field>
							</v-col>
						</v-row>
						<v-row
							justify="end">
							<v-btn color="primary" @click="newBill()"> Add </v-btn>
							<v-btn color="error" class="ml-2 mr-3" @click="bill_dialog = !bill_dialog"> Close </v-btn>
						</v-row>
					</v-container>
				</v-card-text>
			</v-card>
		</v-dialog>

		<v-text-field
			v-model="search"
			label="Search Account Name"
			append-icon="search"
			class="mt-3"
			hide-details
			:color="color">
		</v-text-field>

		<v-data-table 
			:headers="headers_bills" 
			:items="bills" 
			:loading="loading" 
			:loading-text="loading_text" 
			:search="search" 
			:items-per-page="10" 
			class="mt-5 elevation-1">

			<template v-slot:item.action="{ item }">
				<v-tooltip bottom>
					<template v-slot:activator="{ on }">
						<span v-on="on">
							<v-chip @click="viewBill(item)" id="qchip3">
								<v-icon color="teal" small>visibility</v-icon>
							</v-chip>
						</span>
						
					</template>

					<span> View Bill </span>
				</v-tooltip>

				<v-tooltip bottom>
					<template v-slot:activator="{ on }">
						<span v-on="on">
							<v-chip @click="getBillInfo(item)" class="ml-1" id="qchip3">
								<v-icon color="primary" small> edit</v-icon>
							</v-chip>
						</span>
						
					</template>
					<span> Edit Bill </span>
				</v-tooltip>
				
				<v-tooltip bottom>
					<template v-slot:activator="{ on }">
						<span v-on="on">
							<v-chip @click="deleteBill(item)" class="ml-1" id="qchip3">
								<v-icon color="error" small> delete</v-icon>
							</v-chip>
						</span>
					</template>
					<span> Delete Bill </span>
				</v-tooltip>
			</template>
		</v-data-table>

		<v-dialog v-model="view_bill" max-width="800px">
			<v-card>
				<v-card-title> View Bill </v-card-title>
				<v-card-text>
					<v-container>
						<v-row>
							<v-col cols="6">
								<v-text-field label="Service Provider" v-model="view_service_provider" outlined readonly :color="color"></v-text-field>
							</v-col>
							<v-col cols="6">
								<v-text-field label="Account Name" v-model="view_account_name" outlined readonly :color="color"></v-text-field>
							</v-col>
						</v-row>
						<v-row>
							<v-col cols="6">
								<v-text-field label="Account Number" v-model="view_account_number" outlined readonly :color="color"></v-text-field>
							</v-col>
							<v-col cols="6">
								<v-text-field label="Tel No/Service ID No" v-model="view_tel_no" outlined readonly :color="color"></v-text-field>
							</v-col>
						</v-row>
						<v-row>
							<v-col cols="6">
								<v-text-field label="Created by" v-model="view_created_by" outlined readonly :color="color"></v-text-field>
							</v-col>
						</v-row>
						<v-row
							justify="end">											
							<v-btn color="error" class="mr-3" @click="view_bill = !view_bill"> Close </v-btn>
						</v-row>
					</v-container>
				</v-card-text>
			</v-card>
		</v-dialog>

		<v-dialog v-model="edit_bill" max-width="700px" persistent>
			<v-card>
				<v-card-title> Edit Bill </v-card-title>
				<v-card-text>
					<v-container>
						<v-row>
							<v-col cols="12">
								<v-input v-model="billID" hideDetails></v-input>
								<v-combobox
									v-model="bill"
									:items="service_providers"
									item-text="name"
									item-value="name"
									label="Service Provider"
									:color="color"
									:item-color="color">										
								</v-combobox>
								<v-text-field type="text" v-model="accountName" label="Account Name" :color="color"></v-text-field>
								<v-text-field type="text" v-model="accountNumber" label="Account Number" :color="color" maxlength="20"></v-text-field>
								<v-text-field type="text" v-model="telNum" label="Tel No / Service ID No" :color="color" maxlength="20"></v-text-field>
								<v-text-field type="text" v-model="createdBy" label="Created By" :color="color" readonly></v-text-field>
							</v-col>
						</v-row>
						<v-row
							justify="end">
							<v-btn color="primary" @click="updateBill()"> Update </v-btn>
							<v-btn color="error" class="ml-2 mr-3" @click="edit_bill = !edit_bill"> Close </v-btn>
						</v-row>
					</v-container>
				</v-card-text>
			</v-card>
		</v-dialog>

	</v-container>
</template>

<script>
	import { API , token , tokenName } from '../main'
	
	export default {
		data () {
			return {
				clipped: false,
				view_bill: false,
				bill_dialog: false ,
				edit_bill: false ,
				search: "" ,
				switch1: true , 
				dark: false ,

				/* Datatables Settings */
				loading: true ,
				loading_text: "Loading ... Please Wait" ,
				/* Datatables Settings */

				service_providers: [] ,
				bills: [] ,
				headers_bills: [
					{
						text: "Account Name" ,
						value: 'account_name'
					} ,
					{
						text: "Service Provider" ,
						sortable: false ,
						value: 'bill' ,
					} ,
					{
						text: "Account Number" ,
						value: 'account_number' ,
						align: 'left'
					} , 
					{
						text: "Tel No / Service ID No" ,
						value: 'tel_no' ,
					} ,
					{
						text: "Created By" ,
						value: 'created_by'
					} ,
					{
						text: "Action" ,
						value: "action" ,
						align: "center" ,
						sortable: false ,
					}
				] ,

				service_provider: "" ,
				account_name: "" ,
				account_number: 0,
				tel_no: 0 ,
				created_by: tokenName ,
				billID: "",
				bill: "",
				accountName: "",
				accountNumber: 0,
				telNum: 0,
				createdBy: tokenName ,

				/* View Bill */
				view_service_provider: "" ,
				view_account_name: "" ,
				view_account_number: 0 ,
				view_tel_no: 0 ,
				view_created_by: 0 ,

				// validation pattern
				stringPattern: /^[A-Za-z0-9 .-]*$/,
				numberPattern: /^[0-9-]*$/,
				telNumPattern: /^[0-9]*$/,
				color: null ,
			}
		},
		methods:{
			newBill(){
				let billItem = {
					sProvider: this.service_provider.name,
					aName    : this.account_name,
					aNumber  : this.account_number,
					tNum     : this.tel_no,
					cBy      : this.created_by
				};
				let aNameFound = false;
				let aNumberFound = false;
				let telNumFound = false;
				if(!billItem.sProvider || !billItem.aName.trim() || !billItem.aNumber.toString().trim() || !billItem.tNum.toString().trim() || !billItem.cBy.trim()){
					this.$swal('ERROR', 'All fields are required', 'error');
				}else{
					if(billItem.aName.match(this.stringPattern) == null){
						this.$swal('ERROR', 'Invalid character on Account Name', 'error');
					}else if(billItem.aNumber.toString().match(this.numberPattern) == null){
						this.$swal('ERROR', 'Invalid character on Account Number', 'error');
					}else if(billItem.tNum.toString().match(this.telNumPattern) == null){
						this.$swal('ERROR', 'Tel No/Service ID only accept number', 'error');
					}
					else{
						let status = 0;
						fetch(API + '/find/bills')
						.then(response => response.json())
						.then(data => {
							for(var a = 0; a < data.length; a++){
								if(data[a].account_name == this.account_name){
									aNameFound = true;
									status = data[a].status;
								}else if(data[a].account_number == this.account_number){
									aNumberFound = true;
									status = data[a].status;
								}else if(data[a].tel_no == this.tel_no){
									telNumFound = true;
									status = data[a].status;
								}
							}
							if(aNameFound){
								if(status == 1){
									this.$swal('ERROR', 'Account name already use', 'error');
								}else{
									this.$swal('ERROR', 'Account name already use by bill located on trash', 'error');
								}
							}else if(aNumberFound){
								if(status == 1){
									this.$swal('ERROR', 'Account number already use', 'error');
								}else{
									this.$swal('ERROR', 'Account number already use by bill located on trash', 'error');
								}
							}else if(telNumFound){
								if(status == 1){
									this.$swal('ERROR', 'Tel No./Service ID No. already use', 'error');
								}else{
									this.$swal('ERROR', 'Tel No./Service ID No. already use by bill located on trash', 'error');
								}
							}else{
								fetch(API + '/add/new/bills', {
									method: 'post',
									headers: {
											'Content-Type': 'application/json'},
									body: JSON.stringify(billItem)
								}).then(response => response.json())
								.then(data => {
									if(data.affectedRows > 0){
										this.$swal('SUCCESS', 'Bill added successfully', 'success');
										this.bill_dialog = false;
										this.getBills();
										this.service_provider = "";
										this.account_name     = "";
										this.account_number   = 0;
										this.tel_no           = 0;
									}
								});
							}
						});
					}
				}
			} ,

			getBillInfo(item){
				this.edit_bill     = true;
				this.billID        = item.bill_id;
				this.bill          = item.bill;
				this.accountName   = item.account_name;
				this.accountNumber = item.account_number;
				this.telNum        = item.tel_no;
			},

			viewBill(item){
				this.view_bill             = true;
				this.view_service_provider = item.bill;
				this.view_account_name     = item.account_name;
				this.view_account_number   = item.account_number;
				this.view_tel_no		   = item.tel_no;
				this.view_created_by 	   = item.created_by;
			} ,

			closeViewBill () {
				this.view_bill = false;
			} ,

			updateBill(){
				let billItem = {
					billID   : this.billID,
					sProvider: this.bill,
					aName    : this.accountName,
					aNumber  : this.accountNumber,
					tNum     : this.telNum,
					cBy      : this.createdBy
				};
				if(!billItem.sProvider || !billItem.aName || !billItem.aNumber.toString().trim() || !billItem.tNum.toString().trim() || !billItem.cBy){
					this.$swal('ERROR', 'All fields are required', 'error');
				}else{
					if(billItem.aName.match(this.stringPattern) == null){
						this.$swal('ERROR', 'Invalid character on Account Name', 'error');
					}else if(billItem.aNumber.toString().match(this.numberPattern) == null){
						this.$swal('ERROR', 'Invalid character on Account Number', 'error');
					}else if(billItem.tNum.toString().match(this.telNumPattern) == null){
						this.$swal('ERROR', 'Tel No/Service ID only accept number', 'error');
					}else{
						let aNameFound = false;
						let aNumberFound = false;
						let telNumFound = false;
						let status = 0;
						fetch(API + '/get/bill/billid/' + billItem.billID)
						.then(response => response.json())
						.then(data => {
							for(var a = 0; a < data.length; a++){
								if(data[a].account_name == billItem.aName){
									aNameFound = true;
									status = data[a].status;
								}else if(data[a].account_number == billItem.aNumber){
									aNumberFound = true;
									status = data[a].status;
								}else if(data[a].tel_no == billItem.tNum){
									telNumFound = true;
									status = data[a].status;
								}
							}

							if(aNameFound){
								if(status == 1){
									this.$swal("ERROR", 'Account Name is already use', 'error');
								}else{
									this.$swal("ERROR", 'Account Name is already use by bill located on trash', 'error');
								}
							}else if(aNumberFound){
								if(status == 1){
									this.$swal("ERROR", 'Account Number is already use', 'error');
								}else{
									this.$swal("ERROR", 'Account Number is already use by bill located on trash', 'error');
								}
							}else if(telNumFound){
								if(status == 1){
									this.$swal("ERROR", 'Tel No./Service ID is already use', 'error');
								}else{
									this.$swal("ERROR", 'Tel No./Service ID is already use by bill located on trash', 'error');
								}
							}else{
								fetch(API + '/update/bills/',{
									method: 'post',
									headers: {
										'Content-Type': 'application/json'
									},
									body: JSON.stringify(billItem)
								}).then(response => response.json())
								.then(data => {
									if(data.affectedRows > 0){
										this.$swal("SUCCESS", "Bill updated successfully", "success");
										this.edit_bill = false;
										this.getBills();
									}else{
										this.$swal("ERROR", "Update failed", "error");
									}
								});
							}
						});
					}
				}
			},
			deleteBill(item){

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
						fetch(API + '/delete/bills',{
							method: 'post',
							headers:{
								'Content-Type': 'application/json'
							},
							body: JSON.stringify({billID : item.bill_id})
						}).then(response => response.json())
						.then(data =>{
							if(data.affectedRows > 0){
								this.$swal('SUCCESS', 'Bill deleted successfully', 'success');
								this.getBills();
							}else{
								this.$swal('ERROR', 'Delete failed', 'error');
							}
						});
					}
				});
			} ,

			getBills () {
				fetch(API + '/get/bills')
				.then(response => response.json())
				.then(data => {
					this.bills   = data;
					this.loading = false;
				});
			} ,

			getServiceProviders (){
				fetch(API + '/get/service_provider/')
				.then( data => {
					return data.json();
				})
				.then(json => {
					this.service_providers = json;
				});
			} ,

			getActiveColor () {
				fetch(API + '/get/active/color/' + token)
				.then(response => response.json())
				.then(data => {
					this.color = data[0].color;
				});
			} ,
		},
		
		beforeMount () {
			this.$emit('verify');
			this.getActiveColor();
			this.getBills();
			this.getServiceProviders();
		} ,
	}
</script>