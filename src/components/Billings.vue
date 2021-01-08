<template>
	<v-container fluid>
		<v-btn
			:color="color"
			dark					
			class="mt-2"
			@click="billings_dialog = !billings_dialog">
			New Billing
		</v-btn>

		<v-dialog v-model="billings_dialog" max-width="700px" persistent>
			<v-card>
				<v-card-title> New Billing </v-card-title>

				<v-card-text>
					<v-container>
						<v-row>
							<template
								v-if="account_number_status">
								<v-col cols="12" sm="4">
									<template
										v-if="bills.length === 0">
										<v-combobox
											disabled
											label="Please add a Bill first">
										</v-combobox>
									</template>

									<template
										v-else>
										<v-combobox
											v-model="account_name"
											label="Account Name"
											item-text="account_name"
											item-value="bill_id"
											:items="bills"
											@change="accountChange(account_name)"
											:color="color"
											:item-color="color">
										</v-combobox>
									</template>
								</v-col>

								<v-col cols="12" sm="4">
									<v-text-field
										readonly
										v-model="account_number"
										label="Account Number"
										:color="color">
									</v-text-field>
								</v-col>

								<v-col cols="12" sm="4">
									<v-text-field
										v-model="soa_number"
										type="text"
										label="SOA Number"
										:color="color"
										maxlength="20">
									</v-text-field>
								</v-col>										
							</template>

							<template v-else>
								<v-col cols="12" sm="6">
									<template
										v-if="bills.length === 0">
										<v-combobox
											disabled
											label="Please add a Bill first">
										</v-combobox>
									</template>
									<template
										v-else>
										<v-combobox
											v-model="account_name"
											label="Account Name"
											item-text="account_name"
											item-value="bill_id"
											:items="bills"
											@change="accountChange(account_name)"
											:color="color"
											:item-color="color">
										</v-combobox>
									</template>
								</v-col>

								<v-col cols="12" sm="6">
									<v-text-field
										v-model="soa_number"
										type="text"
										label="SOA Number"
										:color="color"
										maxlength="20">
									</v-text-field>
								</v-col>
							</template>

							<v-col cols="12" sm="4">
								<v-menu
									:close-on-content-click="false"
									ref="startMenu1"
									v-model="startMenu1"
									:nudge-right="50"
									:return-value.sync="start_date"
									transition="scale-transition"
									min-width="290px"
									offset-y>

									<template v-slot:activator="{ on }">
										<v-text-field
											v-model="start_date"
											label="Billing Period: Start Date"
											readonly
											v-on="on"
											:color="color"
										></v-text-field>
									</template>
									
									<v-date-picker
										v-model="start_date"
										no-title
										scrollable>
										<v-spacer></v-spacer>
										<v-btn
											:color="color"
											text
											@click="startMenu1 = false">
											Cancel
										</v-btn>
										<v-btn
											:color="color"
											text
											@click="$refs.startMenu1.save(start_date)">
											OK
										</v-btn>
									</v-date-picker>
								</v-menu>
							</v-col>

							<v-col cols="12" sm="4">
								<v-menu
									ref="startMenu2"
									v-model="startMenu2"
									:close-on-content-click="false"
									:nudge-right="50"
									:return-value.sync="end_date"
									transition="scale-transition"
									min-width="290px"
									offset-y>

									<template v-slot:activator="{ on }">
										<v-text-field
											v-model="end_date"
											label="Billing Period: End Date"
											readonly
											v-on="on"
											:color="color"
										></v-text-field>
									</template>
									
									<v-date-picker
										v-model="end_date"
										no-title
										scrollable>
										<v-spacer></v-spacer>
										<v-btn
											:color="color"
											text
											@click="startMenu2 = false"
										>
										Cancel
										</v-btn>
										<v-btn
											:color="color"
											text
											@click="$refs.startMenu2.save(end_date)">
											OK
										</v-btn>
									</v-date-picker>
								</v-menu>
							</v-col>

							<v-col cols="12" sm="4">
								<v-menu
									ref="startMenu3"
									v-model="startMenu3"
									:close-on-content-click="false"
									:nudge-right="50"
									:return-value.sync="due_date"
									transition="scale-transition"
									min-width="290px"
									offset-y>

									<template v-slot:activator="{ on }">
										<v-text-field
											v-model="due_date"
											label="Due Date"
											readonly
											v-on="on"
											:color="color"
										></v-text-field>
									</template>
									
									<v-date-picker
										v-model="due_date"
										no-title
										scrollable>
										<v-spacer></v-spacer>
										<v-btn
											:color="color"
											text
											@click="startMenu3 = false">
											Cancel
										</v-btn>
										<v-btn
											:color="color"
											text
											@click="$refs.startMenu3.save(due_date)">
											OK
										</v-btn>
									</v-date-picker>
								</v-menu>
							</v-col>

							<v-col cols="12" sm="4">
								<v-text-field
									v-model="amount"
									type="number"
									label="Amount"
									:color="color">
								</v-text-field>
							</v-col>	

							<v-col cols="12" sm="4">
								<v-menu
									ref="startMenu4"
									v-model="startMenu4"
									:close-on-content-click="false"
									:nudge-right="50"
									:return-value.sync="date_recieved"
									transition="scale-transition"
									min-width="290px"
									offset-y>

									<template v-slot:activator="{ on }">
										<v-text-field
											v-model="date_recieved"
											label="Date Received"
											readonly
											v-on="on"
											:color="color"
										></v-text-field>
									</template>
									
									<v-date-picker
										v-model="date_recieved"
										no-title
										scrollable>
										<v-spacer></v-spacer>
										<v-btn
											:color="color"
											text
											@click="startMenu4 = false">
											Cancel
										</v-btn>
										<v-btn
											:color="color"
											text
											@click="$refs.startMenu4.save(date_recieved)">
											OK
										</v-btn>
									</v-date-picker>
								</v-menu>
							</v-col>

							<v-col cols="12" sm="4">
								<v-text-field
									v-model="created_by"
									type="text"
									label="Created By"
									readonly
									:color="color">
								</v-text-field>
							</v-col>

							<v-col cols="12">
								<v-textarea
									v-model="remarks"
									style="margin-top: -20px;"
									:color="color"
									auto-grow
									clearable
									clear-icon="cancel"
									label="Remarks">
								</v-textarea>
							</v-col>
								
						</v-row>
						<v-row
							justify="end">
							<v-btn color="primary" @click="addBilling"> Add </v-btn>
							<v-btn color="error" class="ml-2 mr-3" @click="billings_dialog = !billings_dialog"> Close </v-btn>
						</v-row>
					</v-container>
				</v-card-text>
			</v-card>
		</v-dialog>

		<template v-if="billings.length === 0">
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
			:headers="headers_billings"
			:items="billings"
			:search="search"
			:loading="loading"
			:loading-text="loading_text"
			:items-per-page="10"
			class="mt-5 elevation-1">

			<template v-slot:item.account_name="{ item }">
				<small>
					{{ item.account_name }}
				</small>
			</template>

			<template v-slot:item.billing_id="{ item }">
				<v-btn :color="color" text small :to="'/view/' + item.billing_id"> {{item.billing_id}} </v-btn>
			</template>

			<template v-slot:item.soa_number="{ item }">
				<small>
					{{ item.soa_number }}	
				</small>
			</template>

			<template v-slot:item.account_number="{ item }">
				<small>
					{{ item.account_number }}
				</small>
			</template>

			<template v-slot:item.due_date="{ item }">
				<small>
					{{ item.due_date | moment('MM-DD-YYYY') }}
				</small>
			</template>

			<template v-slot:item.amount="{ item }">
				<small>
					{{ item.amount }}
				</small>
			</template>
			
			<template v-slot:item.bill_received_date="{ item }">
				<small>
					{{ item.bill_received_date | moment('MM-DD-YYYY') }}
				</small>
			</template>

			<template v-slot:item.payment_status="{ item }">
				<div v-if="item.payment_status === 1">
					<v-chip color="teal" small dark>
						Paid
					</v-chip>
				</div>
				<div v-else>
					<v-chip color="error" small> Unpaid </v-chip>
				</div>
			</template>

			<template v-slot:item.action="{ item }">
					
				<v-tooltip left v-if="item.payment_status === 0">
					<template v-slot:activator="{ on }">
						<span v-on="on">
							<v-chip
								small
								class="mt-1"
								@click="editBilling(item)"
								id="qchip3">
								<v-icon
									color="primary"
									small>
									edit
								</v-icon>
							</v-chip>
						</span>
					</template>

					<span> Edit Billing </span>
				</v-tooltip>	

				<v-tooltip left v-if="item.payment_status === 0">
					<template v-slot:activator="{ on }">
						<span v-on="on">
							<v-chip
								class="mt-1 mb-1"
								small
								@click="deleteBilling(item)">
								<v-icon
									color="error"
									small>
									delete
								</v-icon>
							</v-chip>
						</span>
					</template>
					<span> Delete Billing </span>
				</v-tooltip>

			</template>	
		</v-data-table>

		<v-dialog v-model="edit_billing_dialog" max-width="700px" persistent>
			<v-card>
				<v-card-title> Edit Billing </v-card-title>

				<v-card-text>
					<v-container>
						<v-row>
							<v-col cols="12" sm="4">
								<v-select
									v-model="edit_account_name"
									label="Account Name"
									item-text="account_name"
									item-value="bill_id"
									:items="bills"
									@change="editAccountChange(edit_account_name)"
									:color="color"
									:item-color="color">
								</v-select>
							</v-col>
							<v-col cols="12" sm="4">
								<v-text-field
									readonly
									v-model="edit_account_number"
									label="Account Number"
									:color="color">
								</v-text-field>
							</v-col>
							<v-col cols="12" sm="4">
								<v-text-field
									v-model="edit_soa_number"
									label="SOA Number"
									:color="color"
									maxlength="20">
								</v-text-field>

							</v-col>

							<v-col cols="12" sm="4">
								<v-menu
									ref="startMenu5"
									v-model="startMenu5"
									:close-on-content-click="false"
									:nudge-right="50"
									:return-value.sync="edit_start_date"
									transition="scale-transition"
									min-width="290px"
									offset-y>

									<template v-slot:activator="{ on }">
										<v-text-field
											v-model="edit_start_date"
											label="Billing Period: Start Date"
											readonly
											v-on="on"
											:color="color"
										></v-text-field>
									</template>
									
									<v-date-picker
										v-model="edit_start_date"
										no-title
										scrollable>
										<v-spacer></v-spacer>
										<v-btn
											:color="color"
											text
											@click="startMenu5 = false">
											Cancel
										</v-btn>
										<v-btn
											:color="color"
											text
											@click="$refs.startMenu5.save(edit_start_date)">
											OK
										</v-btn>
									</v-date-picker>
								</v-menu>
							</v-col>

							<v-col cols="12" sm="4">
								<v-menu
									ref="startMenu6"
									v-model="startMenu6"
									:close-on-content-click="false"
									:nudge-right="50"
									:return-value.sync="edit_end_date"
									transition="scale-transition"
									min-width="290px"
									offset-y>

									<template v-slot:activator="{ on }">
										<v-text-field
											v-model="edit_end_date"
											label="Billing Period: End Date"
											readonly
											v-on="on"
											:color="color"
										></v-text-field>
									</template>
									
									<v-date-picker
										v-model="edit_end_date"
										no-title
										scrollable>
										<v-spacer></v-spacer>
											<v-btn
											:color="color"
											text
											@click="startMenu6 = false">
											Cancel
										</v-btn>
										<v-btn
											:color="color"
											text
											@click="$refs.startMenu6.save(edit_end_date)">
											OK
										</v-btn>
									</v-date-picker>
								</v-menu>
							</v-col>

							<v-col cols="12" sm="4">
								
								<v-menu
									ref="startMenu7"
									v-model="startMenu7"
									:close-on-content-click="false"
									:nudge-right="50"
									:return-value.sync="edit_due_date"
									transition="scale-transition"
									min-width="290px"
									offset-y>

									<template v-slot:activator="{ on }">
										<v-text-field
											v-model="edit_due_date"
											label="Due Date"
											readonly
											v-on="on"
											:color="color"
										></v-text-field>
									</template>
									
									<v-date-picker
										v-model="edit_due_date"
										no-title
										scrollable>
										<v-spacer></v-spacer>
										<v-btn
											:color="color"
											text
											@click="startMenu7 = false">
											Cancel
										</v-btn>
										<v-btn
											:color="color"
											text
											@click="$refs.startMenu7.save(edit_due_date)">
											OK
										</v-btn>
									</v-date-picker>
								</v-menu>
							</v-col>

							<v-col cols="12" sm="4">
								<v-text-field
									v-model="edit_amount"
									type="number"
									label="Amount"
									:color="color">
								</v-text-field>
								
							</v-col>

							<v-col cols="12" sm="4">
								<v-menu
									ref="startMenu8"
									v-model="startMenu8"
									:close-on-content-click="false"
									:nudge-right="50"
									:return-value.sync="edit_date_recieved"
									transition="scale-transition"
									min-width="290px"
									offset-y>

									<template v-slot:activator="{ on }">
										<v-text-field
											v-model="edit_date_recieved"
											label="Date Received"
											readonly
											v-on="on"
											:color="color"
										></v-text-field>
									</template>
									
									<v-date-picker
										v-model="edit_date_recieved"
										no-title
										scrollable>
										<v-spacer></v-spacer>
										<v-btn
											:color="color"
											text
											@click="startMenu8 = false">
										Cancel
										</v-btn>
										<v-btn
											:color="color"
											text
											@click="$refs.startMenu8.save(edit_date_recieved)">
											OK
										</v-btn>
									</v-date-picker>
								</v-menu>
							</v-col>

							<v-col cols="12" sm="4">
								<v-text-field
									v-model="edit_created_by"
									type="text"
									readonly
									label="Created By"
									:color="color">
								</v-text-field>
							</v-col>

							<v-col cols="12">
								<v-textarea
									v-model="edit_remarks"
									style="margin-top: -20px;"
									:color="color"
									auto-grow
									clearable
									clear-icon="cancel"
									label="Remarks">
								</v-textarea>
							</v-col>
						</v-row>
						<v-row
							justify="end">
							<v-btn color="primary" @click="updateBilling"> Save </v-btn>
							<v-btn color="error" class="ml-2 mr-3" @click="edit_billing_dialog = !edit_billing_dialog"> Close </v-btn>
						</v-row>
					</v-container>
				</v-card-text>
			</v-card>
		</v-dialog>
	</v-container>
</template>

<script>
	import { API , token , tokenName } from '../main'
	import moment from 'moment'

	export default {		
		data () {
			return {
				startMenu1: false ,
				startMenu2: false ,
				startMenu3: false ,
				startMenu4: false ,
				startMenu5: false ,
				startMenu6: false ,
				startMenu7: false ,
				startMenu8: false ,
				search: "" ,
				color: null ,
				switch1: true ,
				dark: false ,

				/* Datatables Settings */
				loading: true ,
				loading_text: "Loading ... Please Wait" ,
				/* Datatables Settings */

				billings_dialog: false ,
				edit_billing_dialog: false ,
				new_payment: false ,
				add_attachment: false ,
				account_number_status: false ,

				account_name: "" ,
				account_number: 0 ,
				soa_number: 0 ,
				start_date: moment().format("YYYY-MM-DD") ,
				end_date: moment().format("YYYY-MM-DD") ,
				amount: 0 ,
				due_date: moment().format("YYYY-MM-DD") ,
				date_recieved: moment().format("YYYY-MM-DD") ,
				created_by: tokenName ,
				remarks: "" ,

				edit_account_name: "" ,
				edit_account_number: 0 ,
				edit_soa_number: "" ,
				edit_start_date: "" ,
				edit_end_date: "" ,
				edit_amount: 0 ,
				edit_due_date: "" ,
				edit_date_recieved: "" ,
				edit_created_by: tokenName ,
				edit_remarks: "" ,

				new_start_date: moment().format("YYYY-MM-DD") ,
				new_end_date: moment().format("YYYY-MM-DD") ,
				new_due_date: moment().format("YYYY-MM-DD") ,
				new_date_recieved: moment().format("YYYY-MM-DD") ,

				bills: [] ,
				billings: [] ,
				headers_billings: [
					{
						text: "Account Name" ,
						value: "account_name"
					} ,
					{
						text: "Billing" ,
						value: "billing_id" ,
						align: "left" 
					} ,
					{
						text: "SOA Number" ,
						value: "soa_number" ,
						align: "left"
					} ,
					{
						text: "Account Number" ,
						value: "account_number" ,
					} ,
					{
						text: "Due Date" ,
						value: "due_date" ,
						align: 'left'
					} ,
					{
						text: "Amount" ,
						value: "amount" ,
					} , 
					{
						text: "Date Received" ,
						value: "bill_received_date" ,
					} ,
					{
						text: "Payment Status" ,
						value: "payment_status" ,
						align: "center" ,
					} ,
					{
						text: "Action" ,
						value: "action" ,
						align: "center" ,
						sortable: false 
					}
				],

				namePattern: /^[A-Za-z .-]*$/,
				soaPattern: /^[A-Za-z0-9 -]*$/,
			}
		} ,

		methods: {
			addBilling () {

				let billing = {
					account_name : this.account_name.bill_id ,
					soa_number   : this.soa_number.trim() ,
					amount       : this.amount ,
					due_date     : this.due_date ,
					start_date   : this.start_date ,
					end_date     : this.end_date ,
					date_recieved: this.date_recieved ,
					created_by   : this.created_by ,
					remarks      : this.remarks ,
				};

				if (!billing.account_name.trim() || !billing.amount || !billing.due_date || !billing.start_date || !billing.end_date || !billing.date_recieved || !billing.created_by.trim()) {
					
					this.$swal(
						'ERROR!' , 
						'All fields are required' , 
						'error'
					);
				
				} else {
					if(billing.soa_number.match(this.soaPattern) == null){
						this.$swal("ERROR", "Invalid character on SOA Number", "error");
					}else if(billing.amount.length > 20){
						this.$swal("ERROR", "Amount only accept 20 digits of number", "error");
					}else{
						
						billing.amount = parseFloat(billing.amount).toFixed(2);

						fetch(API + "/check/trash/billings/" + billing.soa_number)
						.then(data => {
							return data.json();
						})
						.then(json => {

							if (json.success === true) {
								this.$swal(
									'SORRY!' , 
									'Soa Number is already use Located in Trash' , 
									'error'
								);
							} else {

								fetch(API + '/add/new/billing/', { 
									method: 'post',
									headers: {
											'Content-Type': 'application/json'},
									body: JSON.stringify(billing)
								}).then(data => {
							
									return data.json(); 
							
								}).then(json => {

									if(json.success === true) {

										this.$swal(
											'Success' , 
											'New Billing Successfully Added!' , 
											'success'
										);

										this.billings_dialog       = false;
										this.account_name          = "";
										this.account_number_status = false;
										this.soa_number 	 = 0;
										this.start_date      = moment().format("YYYY-MM-DD");
										this.end_date 	     = moment().format("YYYY-MM-DD");
										this.amount 		 = 0;
										this.due_date 	     = moment().format("YYYY-MM-DD");
										this.date_created 	 = moment().format("YYYY-MM-DD");
										this.remarks         = "";

										this.getBillings();

									} else if (json.success === false ){

										this.$swal(
											'ERROR!' , 
											'Soa Number is Already Use , Please Try Again.' , 
											'error'
										);

									} else {
										this.$swal(
											'ERROR!' , 
											'Something Went Wrong , Please Try Again!' , 
											'error'
										);
									}
								});
							}
						});
					}
				}
			} ,

			editBilling (item) {
				this.edit_billing_dialog       = true;
				this.edit_billing_id           = item.billing_id;
				this.edit_billing_account_name = item.account_name;
				this.edit_account_name         = item.bill_id;
				this.edit_account_number       = item.account_number;
				this.edit_soa_number     	   = item.soa_number;
				this.edit_start_date    	   = moment(item.billing_period_start).format("YYYY-MM-DD");
				this.edit_end_date      	   = moment(item.billing_period_end).format("YYYY-MM-DD");
				this.edit_amount        	   = item.amount;
				this.edit_due_date      	   = moment(item.due_date).format("YYYY-MM-DD");
				this.edit_date_recieved 	   = moment(item.bill_received_date).format("YYYY-MM-DD");
				this.edit_remarks              = item.remarks;
			} ,

			updateBilling () {
				let billing = {
					billID      : this.edit_account_name ,
					billingID   : this.edit_billing_id,
					soaNumber   : this.edit_soa_number.trim(),
					billStart   : this.edit_start_date ,
					billEnd     : this.edit_end_date ,
					amount      : this.edit_amount ,
					dueDate     : this.edit_due_date ,
					dateReceived: this.edit_date_recieved,
					createdBy   : this.edit_created_by,
					remarks 	: this.edit_remarks
				};
				if (!billing.billStart || !billing.billEnd || !billing.amount || !billing.dueDate || !billing.dateReceived || !billing.createdBy.trim()) {
					this.$swal('ERROR!' , 'All fields are required' , 'error');
				
				}else {
					billing.amount = parseFloat(billing.amount).toFixed(2);
					if(billing.soaNumber.match(this.soaPattern) == null){
						this.$swal("ERROR", "Invalid character on SOA Number", "error");
					}else if(billing.amount.length > 20){
						this.$swal("ERROR", "Amount only accept 20 digits of number", "error");
					}else{

						fetch(API + "/check/trash/billings/" + billing.soaNumber)
						.then(data => {
							return data.json();
						})
						.then(json => {

							if (json.success === true) {
								this.$swal(
									'SORRY!' , 
									'Soa Number is already use Located in Trash.' , 
									'error'
								);
							} else {

								fetch(API + '/edit/billings/', { 
									method: 'post',
									headers: {
											'Content-Type': 'application/json'},
									body: JSON.stringify(billing)
								}).then(response => response.json())
								.then(data => {

									if (data.success === true){

										this.$swal("SUCCESS", "Billing updated successfully", "success");
										this.edit_billing_dialog = false;
										this.edit_account_name   = "";
										this.edit_soa_number     = "";
										this.edit_start_date     = moment().format("YYYY-MM-DD");
										this.edit_end_date       = moment().format("YYYY-MM-DD");
										this.edit_amount         = 0;
										this.edit_due_date       = moment().format("YYYY-MM-DD");
										this.edit_date_recieved  = moment().format("YYYY-MM-DD");
										this.getBills();
										this.getBillings();
									
									} else if (data.success === false) {
									
										this.$swal("WARNING", "Soa Number is Already Use , Please Try Again." , "error");
									
									} else {
										
										this.$swal("ERROR", "Update failed", "error");

									}

								});
							}
						});		
					}
				}
			} ,

			deleteBilling (item) {

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
						fetch(API + '/delete/billing/' , {
							method: 'post',
							headers:{
								'Content-Type': 'application/json'
							},
							body: JSON.stringify({ billing_id : item.billing_id })
						}).then(data => {
							return  data.json()
						})
						.then(json =>{
							if(json.success === true){

								this.$swal(
									'SUCCESS' , 
									'Bill deleted successfully' , 
									'success'
								);

								this.getBillings();

							}else{

								this.$swal(
									'ERROR' ,
									'Delete failed' , 
									'error'
								);
							
							}
						});
					}
				});
				
			} ,

			cancelBilling () {
				this.edit_billing       = false;
				this.edit_account_name  = "";
				this.edit_soa_number    = 0;
				this.edit_start_date    = moment().format("YYYY-MM-DD");
				this.edit_end_date      = moment().format("YYYY-MM-DD");
				this.edit_amount		= 0;
				this.edit_due_date      = moment().format("YYYY-MM-DD");
				this.edit_date_recieved = moment().format("YYYY-MM-DD");
			} ,

			getBillings () {
				fetch(API + "/get/billings/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.billings = json;
                    this.loading  = false ;
                });
			} ,

			getBills () {
				fetch(API + "/get/bills/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.bills = json;
                });
			} ,

			accountChange (item) {
				fetch(API + "/get/bills/account_number/" + item.bill_id)
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.account_number        = json.account_number;
                    this.account_number_status = true;
                });
			} ,

			editAccountChange (account_name) {
				fetch(API + "/get/bills/account_number/" + account_name)
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.edit_account_number = json.account_number;
                });
			} ,

			getActiveColor () {
				fetch(API + '/get/active/color/' + token)
				.then(response => response.json())
				.then(data => {
					this.color = data[0].color;

				});
			} ,

			getActiveDarkMode () {
				fetch(API + '/get/dark/mode/' + token)
				.then(response => response.json())
				.then(data => {
					if (data.success === true) {
						this.switch1 = true;
						this.dark    = true;
						this.status  = 1;
					} else {
						this.switch1 = false;
						this.dark    = false;
						this.status  = 0;
					}
				});
			} ,

			dark_mode () {
				let switch1 = this.switch1;

				if (switch1 === false) {
					fetch(API + '/update/dark/mode/' + token + "/" + switch1)
					.then(response => response.json())
					.then(data => {
						if (data.success === true) {		
							this.$emit('getActiveDarkMode');					
							this.getActiveDarkMode();
						} 
					});
				} else {
					fetch(API + '/update/dark/mode/' + token + "/" + switch1)
					.then(response => response.json())
					.then(data => {
						if (data.success === true) {
							this.$emit('getActiveDarkMode');					
							this.getActiveDarkMode();								
						} 
					});
				}
			} ,
		} ,

		beforeMount () {
			this.$emit('verify');
			this.getActiveColor();
			this.getActiveDarkMode();
			this.getBills();
			this.getBillings();
		} ,
	}
</script>

<style lang="scss">
	$orange1: #FF6D00;
	$orange2: #F4511E;
	$orange3: #FF9100;
	$orange4: #D84315;

	#btn1 {
		background-image: linear-gradient(to right, $orange1, $orange2);
	}

	#btn1:hover {
		background-image: linear-gradient(to right, $orange3, $orange4);	
	}

	#btn2 {
		color: #F57C00;
	}
</style>