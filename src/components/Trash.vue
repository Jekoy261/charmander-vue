<template>
	<v-container fluid>
		<v-expansion-panels
			v-model="panel"
			multiple>
			<v-expansion-panel>
				<v-expansion-panel-header> Service Providers </v-expansion-panel-header>
				<v-expansion-panel-content>
					<template
						v-if="service_providers.length === 0">
					</template>

					<template v-else>
						<v-text-field
							v-model="search1"
							append-icon="search"
							label="Search Bill"
							:color="color">
						</v-text-field>
					</template>

					<v-data-table
						:headers="service_providers_header"
						:items="service_providers"
						:loading="loading1"
						:loading-text="loading_text1"
						:search="search1"
						:items-per-page="10"
						class="elevation-1">

						<template v-slot:item.date_created="{ item }">
							{{ item.date_created | moment("YYYY-MM-DD") }}
						</template>

						<template v-slot:item.action="{ item }">
							<v-tooltip left>
								<template v-slot:activator="{ on }">
									<span v-on="on">
										<v-chip @click="retrieveServiceProvider(item)" >
											<v-icon
												color="teal"
												small>
												restore_from_trash
											</v-icon>
										</v-chip>
									</span>
								</template>
								<span> Retrieve Service Provider </span>
							</v-tooltip>	

							<v-tooltip bottom>
								<template v-slot:activator="{ on }">
									<span v-on="on">
										<v-chip class="ml-1" @click="permanentDeleteServiceProvider(item)" >
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

				</v-expansion-panel-content>
			</v-expansion-panel>

			<v-expansion-panel>
				<v-expansion-panel-header> Bills </v-expansion-panel-header>
				<v-expansion-panel-content>
					
					<template
						v-if="bills.length === 0">
					</template>

					<template v-else>
						<v-text-field
							v-model="search2"
							append-icon="search"
							label="Search Bill"
							:color="color">
						</v-text-field>
					</template>

					<v-data-table
						:headers="bills_header"
						:items="bills"
						:loading="loading2"
						:loading-text="loading_text2"
						:search="search2"
						:items-per-page="10"
						class="elevation-1">

						<template v-slot:item.bill_id="{ item }">
							<small>
								{{ item.bill_id }}
							</small>
						</template>

						<template v-slot:item.bill="{ item }">
							<small>
								{{ item.bill }}
							</small>
						</template>

						<template v-slot:item.account_name="{ item }">
							<small>
								{{ item.account_name }}
							</small>
						</template>

						<template v-slot:item.account_number="{ item }">
							<small>
								{{ item.account_number }}
							</small>
						</template>

						<template v-slot:item.tel_no="{ item }">
							<small>
								{{ item.tel_no }}
							</small>
						</template>

						<template v-slot:item.created_by="{ item }">
							<small>
								{{ item.created_by }}
							</small>
						</template>

						<template v-slot:item.date_modified="{ item }">
							<small>
								{{ item.date_modified | moment("YYYY-MM-DD") }}
							</small>
						</template>

						<template v-slot:item.action="{ item }">
							<v-tooltip left>
								<template v-slot:activator="{ on }">
									<span v-on="on">
										<v-chip small class="mt-1" @click="retrieveBill(item)" >
											<v-icon
												color="teal"
												small>
												restore_from_trash
											</v-icon>
										</v-chip>
									</span>
								</template>
								<span> Retrieve Bill </span>
							</v-tooltip>	

							<v-tooltip bottom>
								<template v-slot:activator="{ on }">
									<span v-on="on">
										<v-chip small class="mt-1 mb-1" @click="permanentDeleteBill(item)" >
											<v-icon
												color="error"
												small>
												delete
											</v-icon>
										</v-chip>
									</span>
								</template>
								<span> Delete Bill </span>
							</v-tooltip>
						</template>

					</v-data-table>
				</v-expansion-panel-content>
			</v-expansion-panel>

			<v-expansion-panel>
				<v-expansion-panel-header> Billings </v-expansion-panel-header>
				<v-expansion-panel-content>
					<template
						v-if="billings.length === 0">
					</template>

					<template v-else>
						<v-text-field
							v-model="search3"
							append-icon="search"
							label="Search Billing"
							:color="color">
						</v-text-field>
					</template>

					<v-data-table
						:headers="billings_header"
						:items="billings"
						:loading="loading3"
						:loading-text="loading_text3"
						:search="search3"
						:items-per-page="10"
						class="elevation-1">

						<template v-slot:item.billing_id="{ item }">
							<small>
								{{ item.billing_id }}
							</small>
						</template>

						<template v-slot:item.soa_number="{ item }">
							<small>
								{{ item.soa_number }}
							</small>
						</template>

						<template v-slot:item.account_name="{ item }">
							<small>
								{{ item.account_name }}
							</small>
						</template>

						<template v-slot:item.account_number="{ item }">
							<small>
								{{ item.account_number }}
							</small>
						</template>

						<template v-slot:item.billing_id="{ item }">
							<small>
								{{ item.billing_id }}
							</small>
						</template>

						<template v-slot:item.billing_period="{ item }">
							<small>
								{{ item.billing_period_start | moment("YYYY-MM-DD") }} 
								<b> to </b>
								{{ item.billing_period_end | moment("YYYY-MM-DD") }}
							</small>
						</template>
						
						<template v-slot:item.due_date="{ item }">
							<small>
								{{ item.due_date | moment("YYYY-MM-DD") }}
							</small>
						</template>

						<template v-slot:item.amount="{ item }">
							<small>
								{{ item.amount }}
							</small>
						</template>

						<template v-slot:item.date_modified="{ item }">
							<small>
								{{ item.date_modified | moment("YYYY-MM-DD") }}
							</small>
						</template>

						<template v-slot:item.action="{ item }">
							<v-tooltip left>
								<template v-slot:activator="{ on }">
									<span v-on="on">
										<v-chip small class="mt-1" @click="retrieveBilling(item)" >
											<v-icon
												color="teal"
												small>
												restore_from_trash
											</v-icon>
										</v-chip>
									</span>
								</template>
								<span> Retrieve Billing </span>
							</v-tooltip>	

							<v-tooltip bottom>
								<template v-slot:activator="{ on }">
									<span v-on="on">
										<v-chip small class="mt-1 mb-1" @click="permanentDeleteBilling(item)" >
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
				</v-expansion-panel-content>
			</v-expansion-panel>

			<v-expansion-panel>
				<v-expansion-panel-header> Payments </v-expansion-panel-header>
				<v-expansion-panel-content>
					<template
						v-if="payments.length === 0">
					</template>

					<template v-else>
						<v-text-field
							v-model="search4"
							append-icon="search"
							label="Search Payment"
							:color="color">
						</v-text-field>
					</template>

					<v-data-table
						:headers="payment_header"
						:items="payments"
						:loading="loading4"
						:loading-text="loading_text4"
						:search="search4"
						:items-per-page="10"
						class="elevation-1">

						<template v-slot:item.bill_payment_id="{ item }">
							<small>
								{{ item.bill_payment_id }}
							</small>
						</template>

						<template v-slot:item.billing_id="{ item }">
							<small>
								{{ item.billing_id }}
							</small>
						</template>

						<template v-slot:item.accountable_person="{ item }">
							<small>
								{{ item.accountable_person }}
							</small>
						</template>

						<template v-slot:item.voucher_number="{ item }">
							<small>
								{{ item.voucher_number }}
							</small>
						</template>

						<template v-slot:item.voucher_date="{ item }">
							<small>
								{{ item.voucher_date | moment("YYYY-MM-DD") }}
							</small>
						</template>

						<template v-slot:item.amount="{ item }">
							<small>
								{{ item.amount }}
							</small>
						</template>

						<template v-slot:item.cheque_number="{ item }">
							<small>
								{{ item.cheque_number }}
							</small>
						</template>

						<template v-slot:item.cheque_date="{ item }">
							<small>
								{{ item.cheque_date | moment("YYYY-MM-DD") }}
							</small>
						</template>

						<template v-slot:item.bank="{ item }">
							<small>
								{{ item.bank }}
							</small>
						</template>

						<template v-slot:item.date_modified="{ item }">
							<small>
								{{ item.date_modified | moment("YYYY-MM-DD") }}
							</small>
						</template>

						<template v-slot:item.payment_type="{ item }">
							<div v-if="item.payment_type === 0">
								<v-chip :color="color" small dark>
									Cash
								</v-chip>
							</div>
							<div v-else>
								<v-chip :color="color" dark small> Cheque </v-chip>
							</div>
						</template>

						<template v-slot:item.action="{ item }">
							<v-tooltip left>
								<template v-slot:activator="{ on }">
									<span v-on="on">
										<v-chip small class="mt-1" @click="retrievePayment(item)" >
											<v-icon
												color="teal"
												small>
												restore_from_trash
											</v-icon>
										</v-chip>
									</span>
								</template>
								<span> Retrieve Payment </span>
							</v-tooltip>	

							<v-tooltip bottom>
								<template v-slot:activator="{ on }">
									<span v-on="on">
										<v-chip small class="mt-1 mb-1" @click="permanentDeletePayment(item)" >
											<v-icon
												color="error"
												small>
												delete
											</v-icon>
										</v-chip>
									</span>
								</template>
								<span> Delete Payment </span>
							</v-tooltip>
						</template>
						
					</v-data-table>
				</v-expansion-panel-content>
			</v-expansion-panel>

			<v-expansion-panel>
				<v-expansion-panel-header> Attachments </v-expansion-panel-header>
				<v-expansion-panel-content>
					<template
						v-if="attachments.length === 0">
					</template>

					<template v-else>
						<v-text-field
							v-model="search5"
							append-icon="search"
							label="Search Attachment"
							:color="color">
						</v-text-field>
					</template>
					<v-data-table
						:headers="attachment_header"
						:items="attachments"
						:loading="loading5"
						:loading-text="loading_text5"
						:search="search5"
						:items-per-page="10"
						class="elevation-1">

						<template v-slot:item.attachment_id="{ item }">
							<small>
								{{ item.attachment_id }}
							</small>
						</template>

						<template v-slot:item.billing_id="{ item }">
							<small>
								{{ item.billing_id }}
							</small>
						</template>

						<template v-slot:item.attachment="{ item }">
							<v-card
								class="mt-3 mb-3"
								height="100" 
								width="200"
								@click="view_deleted_image = !view_deleted_image">
								<v-img :src="require('../assets/uploads/' + item.attachment )"></v-img>

								<v-dialog
									v-model="view_deleted_image" max-width="1000px">
									<v-card>
										<v-card-title> View Image </v-card-title>
										
										<v-card-text>
											<v-img :src="require('../assets/uploads/' + item.attachment)"></v-img>
										</v-card-text>

										<v-card-subtitle>
											<v-row
												align="center"
												justify="end">
												<v-btn color="error" class="ml-2 mr-5" @click="view_deleted_image = !view_deleted_image"> Close </v-btn>
											</v-row>
										</v-card-subtitle>
									</v-card>
								</v-dialog>
							</v-card>
						</template>

						<template v-slot:item.created_by="{ item }">
							<small>
								{{ item.created_by }}
							</small>
						</template>

						<template v-slot:item.date_modified="{ item }">
							<small>
								{{ item.date_modified | moment("YYYY-MM-DD") }}
							</small>
						</template>

						<template v-slot:item.action="{ item }">
							<v-tooltip left>
								<template v-slot:activator="{ on }">
									<span v-on="on">
										<v-chip small class="mt-1" @click="retrieveAttachment(item)" >
											<v-icon
												color="teal"
												small>
												restore_from_trash
											</v-icon>
										</v-chip>
									</span>
								</template>
								<span> Retrieve Attachment </span>
							</v-tooltip>	

							<v-tooltip bottom>
								<template v-slot:activator="{ on }">
									<span v-on="on">
										<v-chip small class="mt-1 mb-1" @click="permanentDeleteAttachment(item)" >
											<v-icon
												color="error"
												small>
												delete
											</v-icon>
										</v-chip>
									</span>
								</template>
								<span> Delete Attachment </span>
							</v-tooltip>
						</template>
						
					</v-data-table>
				</v-expansion-panel-content>
			</v-expansion-panel>

			<v-expansion-panel>
				<v-expansion-panel-header> Emails </v-expansion-panel-header>
				<v-expansion-panel-content>
					<template
						v-if="emails.length === 0">
					</template>

					<template v-else>
						<v-text-field
							v-model="search6"
							append-icon="search"
							label="Search Emails"
							:color="color">
						</v-text-field>
					</template>
					<v-data-table
						:headers="email_header"
						:items="emails"
						:loading="loading6"
						:loading-text="loading_text6"
						:search="search6"
						:items-per-page="10"
						class="elevation-1">

						<template v-slot:item.email_id="{ item }">
							<small>
								{{ item.email_id }}
							</small>
						</template>

						<template v-slot:item.email="{ item }">
							<small>
								{{ item.email }}
							</small>
						</template>

						<template v-slot:item.modified_date="{ item }">
							<small>
								{{ item.modified_date | moment("YYYY-MM-DD")}}
							</small>
						</template>
						<template v-slot:item.action="{ item }">
							<v-tooltip left>
								<template v-slot:activator="{ on }">
									<span v-on="on">
										<v-chip small class="mt-1" @click="retrieveEmail(item)" >
											<v-icon
												color="teal"
												small>
												restore_from_trash
											</v-icon>
										</v-chip>
									</span>
								</template>
								<span> Retrieve Email </span>
							</v-tooltip>	

							<v-tooltip bottom>
								<template v-slot:activator="{ on }">
									<span v-on="on">
										<v-chip small class="mt-1 mb-1" @click="permanentDeleteEmail(item)" >
											<v-icon
												color="error"
												small>
												delete
											</v-icon>
										</v-chip>
									</span>
								</template>
								<span> Delete Email </span>
							</v-tooltip>
						</template>
						
					</v-data-table>
				</v-expansion-panel-content>
			</v-expansion-panel>
		</v-expansion-panels>
	</v-container>
</template>

<script>
	import { API , token } from '../main'

	export default {
		data () {
			return {
				view_deleted_image: false ,
				panel: [ 0 , 1 , 2 , 3, 4, 5 ] ,
				search1: "" ,
				search2: "" ,
				search3: "" ,
				search4: "" ,
				search5: "" ,
				search6: "",
				switch1: true ,
				dark: false ,

				color: null ,

				/* Datatables Array */
				service_providers: [] ,
				bills: [] ,
				billings: [] , 
				payments: [] ,
				attachments: [] ,
				emails: [],
				/* Datatables Array */

				/* Datatables Settings */
				loading1: true ,
				loading2: true ,
				loading3: true ,
				loading4: true ,
				loading5: true ,
				loading6: true,
				loading_text1: "Loading Service Providers ... Please Wait" ,
				loading_text2: "Loading Bills ... Please Wait" ,
				loading_text3: "Loading Billings ... Please Wait" ,
				loading_text4: "Loading Payments ... Please Wait" ,
				loading_text5: "Loading Attachments ... Please Wait" ,
				loading_text6: "Loading Emails ... Please Wait",
				
				/* Datatables Headers */
				service_providers_header: [
					{
						text: "Service Provider" ,
						value: "name" ,
						align: "left"
					} ,
					{
						text: "Date Deleted" ,
						value: "date_modified" ,
					} ,
					{
						text: "Actions" ,
						value: "action" ,
						align: "center" ,
						sortable: false ,
					} ,
				] ,

				bills_header: [ 
					{
						text: 'Bill' ,
						value: 'bill_id' ,
						align: 'left' ,

					} ,
					{
						text: 'Service Provider' ,
						value: 'bill' ,
						align: 'center' ,
					} , 
					{
						text: 'Account Name' ,
						value: 'account_name' ,
						align: 'center' ,
					} , 
					{
						text: 'Account Number' ,
						value: 'account_number' ,
						align: 'center' ,
					} , 
					{
						text: 'Tel No. ' ,
						value: 'tel_no' ,
						align: 'center' ,
					} ,
					{
						text: 'Created By' ,
						value: 'created_by' ,
						align: 'center' ,
					} ,
					{
						text: 'Date Deleted' ,
						value: 'date_modified' ,
						align: 'center' ,
					} , 
					{
						text: 'Actions' ,
						value: 'action' ,
						align: 'center' ,
						sortable: false ,
					}
				] ,

				billings_header: [
					{
						text: 'Billing' ,
						value: 'billing_id' ,
						align: 'left' ,
					} , 
					{
						text: 'SOA Number' ,
						value: 'soa_number' ,
						align: 'center' 
					} , 
					{
						text: 'Account Name' ,
						value: 'account_name' ,
						align: 'center'
					} ,
					{
						text: 'Account Number' ,
						value: 'account_number' , 
						align: 'center'
					} , 
					{
						text: 'Billing Period' ,
						value: 'billing_period' ,
						align: 'center'
					} , 
					{
						text: 'Due Date' ,
						value: 'due_date' ,
						align: 'center' 
					} , 
					{
						text: 'Amount' ,
						value: 'amount' ,
						align: 'center'
					} ,
					{
						text: 'Date Deleted' ,
						value: 'date_modified' ,
						align: 'center' ,
					} ,
					{
						text: 'Actions' ,
						value: 'action' ,
						align: 'center' ,
						sortable: false ,
					}
				] ,

				payment_header: [
					{
						text: 'Payment' ,
						value: 'bill_payment_id' ,
						align: 'left' ,
					} ,
					{
						text: 'Billing' ,
						value: 'billing_id' ,
						align: 'center' ,
					} ,
					{
						text: 'Accountable Person' ,
						value: 'accountable_person' ,
						align: 'center' ,
					} , 
					{
						text: 'Voucher Number' ,
						value: 'voucher_number' ,
						align: 'center' ,
					} ,
					{
						text: 'Voucher Date' ,
						value: 'voucher_date' ,
						align: 'center' ,
					} ,
					{
						text: 'Amount' ,
						value: 'amount' ,
						align: 'center' ,
					} ,
					{
						text: 'Cheque Number' ,
						value: 'cheque_number' ,
						align: 'center' ,
					} ,
					{
						text: 'Cheque Date' ,
						value: 'cheque_date' ,
						align: 'center' ,
					} ,
					{
						text: 'Bank' ,
						value: 'bank'  ,
						align: 'center' ,
					} ,
					{
						text: 'Date Deleted' ,
						value: 'date_modified' ,
						align: 'center' ,
					} ,
					{
						text: "Payment Type" ,
						value: 'payment_type' ,
						align: 'center' ,
					} ,
					{
						text: 'Actions' ,
						value: 'action' ,
						align: 'center' ,
						sortable: false ,
					}

				] ,

				attachment_header: [
					{
						text: 'Attachment' ,
						value: 'attachment_id' ,
						align: 'left' ,
					} ,
					{
						text: 'Billing' ,
						value: 'billing_id' ,
						align: 'center' ,
					} , 
					{
						text: 'Attachment Name' ,
						value: 'attachment' ,
						align: 'center' ,
					} , 
					{
						text: 'Created By' ,
						value: 'created_by' ,
						align: 'center' ,
					} , 
					{
						text: 'Date Deleted' ,
						value: 'date_modified' ,
						align: 'center' ,
					} ,
					{
						text: "Actions" ,
						value: 'action' ,
						align: 'center' ,
						sortable: false ,
					}
				] ,
				email_header: [
					{
						text: "Email ID" ,
						value: "email_id"
					} ,
					{
						text: "Email" ,
						value: "email"
					} ,
					{
						text: "Date Deleted" ,
						value: "modified_date" ,
						align: "center" ,
					} ,
					{
						text: "Actions" ,
						value: "action" ,
						sortable: false ,
						align: "center" ,	
					}
				] ,
				/* Datatables Headers */

			}
		} ,

		methods: {
			retrieveServiceProvider (item) {
				let id = item.service_id;

				this.$swal({

					title: 'Are you sure?',
					text: "You want to retrieve this bill",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes, Retrieve it!'

				}).then((result) => {

					if (result.value) { 

						fetch(API + '/retrieve/service_provider/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify({ id: id })
						}).then( data => { 

							return data.json();

						}).then( json => {

							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'Service Provider Retrieve Successfully' , 
									'success'
								);

								this.getDeletedServiceProviders();

							} else {

								this.$swal(
									'ERROR' ,
									'Something Went Wrong , Please Try Again.' , 
									'error'
								);

							}

						});
					}

				});	
			} ,

			retrieveBill (item) {
				let id = item.bill_id;

				this.$swal({

					title: 'Are you sure?',
					text: "You want to retrieve this bill",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes, Retrieve it!'

				}).then((result) => {

					if (result.value) { 

						fetch(API + '/retrieve/bill/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify({ id: id })
						}).then( data => { 

							return data.json();

						}).then( json => {

							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'Bill Retrieve Successfully' , 
									'success'
								);

								this.getDeletedBills();

							} else {

								this.$swal(
									'ERROR' ,
									'Something Went Wrong , Please Try Again.' , 
									'error'
								);

							}

						});
					}

				});	
			} ,

			retrieveBilling (item) {
				let id = item.billing_id;

				this.$swal({

					title: 'Are you sure?',
					text: "You want to retrieve this billing",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes, Retrieve it!'

				}).then((result) => {

					if (result.value) { 

						fetch(API + '/retrieve/billing/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify({ id: id })
						}).then( data => { 

							return data.json();

						}).then( json => {

							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'Billing Retrieve Successfully' , 
									'success'
								);

								this.getDeletedBillings();

							} else {

								this.$swal(
									'ERROR' ,
									'Something Went Wrong , Please Try Again.' , 
									'error'
								);

							}

						});
					}

				});	
			} ,

			retrievePayment (item) {

				let retrieveDetails = {
					id        : item.bill_payment_id ,
					billing_id: item.billing_id ,
				};

				fetch(API + "/check/trash/retrieve/payments/" + retrieveDetails.billing_id)
				.then(data => {
					return data.json();
				})
				.then(json => {

					if (json.success === true) {

						this.$swal(
							'SORRY' ,
							'This Billing ' + retrieveDetails.billing_id + ' already have a payment , You will have a conflict if you retrieve this payment' , 
							'error'
						);

					} else {

						this.$swal({

							title: 'Are you sure?',
							text: "You want to retrieve this payment",
							icon: 'warning',
							showCancelButton: true,
							confirmButtonColor: '#3085d6',
							cancelButtonColor: '#d33',
							confirmButtonText: 'Yes, Retrieve it!'

						}).then((result) => {

							if (result.value) { 

								

								fetch(API + '/retrieve/payment/', { 
									method: 'post',
									headers: {
											'Content-Type': 'application/json'},
									body: JSON.stringify(retrieveDetails)
								}).then( data => { 

									return data.json();

								}).then( json => {

									if (json.success === true) {

										this.$swal(
											'SUCCESS' , 
											'Paymnet Retrieve Successfully' , 
											'success'
										);

										this.getDeletedPayments();

									} else {

										this.$swal(
											'ERROR' ,
											'Something Went Wrong , Please Try Again.' , 
											'error'
										);

									}
								});
							}
						});	
					}
				});
			} ,

			retrieveAttachment (item) {

				let id = item.attachment_id;

				this.$swal({

					title: 'Are you sure?',
					text: "You want to retrieve this attachment",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes, Retrieve it!'

				}).then((result) => {

					if (result.value) { 

						fetch(API + '/retrieve/attachment/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify({ id: id })
						}).then( data => { 

							return data.json();

						}).then( json => {

							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'Attachment Retrieve Successfully' , 
									'success'
								);

								this.getDeletedAttachments();

							} else {

								this.$swal(
									'ERROR' ,
									'Something Went Wrong , Please Try Again.' , 
									'error'
								);

							}

						});
					}

				});	

			} ,

			retrieveEmail (item) {

				let id = item.email_id;

				this.$swal({

					title: 'Are you sure?',
					text: "You want to retrieve this email",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes, Retrieve it!'
				}).then((result) => {

					if (result.value) { 
						fetch(API + '/retrieve/email/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify({ email_id: id })
						}).then( data => { 

							return data.json();

						}).then( json => {

							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'Email Retrieve Successfully' , 
									'success'
								);

								this.getDeletedEmail();

							} else {

								this.$swal(
									'ERROR' ,
									'Something Went Wrong , Please Try Again.' , 
									'error'
								);

							}

						});
					}

				});	

			} ,

			permanentDeleteServiceProvider (item) {

				let id = item.service_id;
				this.$swal({

					title: 'Are you sure?',
					text: "This Service Provider will be permanently delete in the System.",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes, Delete it!'
				}).then((result) => {

					if (result.value) { 
						fetch(API + '/permanent/delete/service_provider/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify({ id: id })
						}).then( data => { 

							return data.json();

						}).then( json => {

							if (json.success === true) {

								this.$swal(
									'SUCCESS' ,
									'Service Provider Deleted Successfully' , 
									'success'
								);

								this.getDeletedServiceProviders();
							} else {

								this.$swal(
									'ERROR' ,
									'Something Went Wrong , Please Try Again.' , 
									'error'
								);

							}

						});
					}

				});	

			} ,

			permanentDeleteBill (item) {

				let id = item.bill_id;

				this.$swal({

					title: 'Are you sure?',
					text: "This bill will be permanently delete in the System.",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes, Delete it!'

				}).then((result) => {

					if (result.value) { 

						fetch(API + '/permanent/delete/bill/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify({ id: id })
						}).then( data => { 

							return data.json();

						}).then( json => {

							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'Bill Deleted Successfully' , 
									'success'
								);

								this.getDeletedBills();

							} else {

								this.$swal(
									'ERROR' ,
									'Something Went Wrong , Please Try Again.' , 
									'error'
								);

							}

						});
					}

				});	

			} ,

			permanentDeleteBilling (item) {

				let id = item.billing_id;

				this.$swal({

					title: 'Are you sure?',
					text: "This bill will be permanently delete in the System.",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes, Delete it!'

				}).then((result) => {

					if (result.value) { 

						fetch(API + '/permanent/delete/billing/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify({ id: id })
						}).then( data => { 

							return data.json();

						}).then( json => {

							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'Bill Deleted Successfully' , 
									'success'
								);

								this.getDeletedBillings();

							} else {

								this.$swal(
									'ERROR' ,
									'Something Went Wrong , Please Try Again.' , 
									'error'
								);

							}

						});
					}

				});

			} ,

			permanentDeletePayment (item) {

				let id = item.bill_payment_id;

				this.$swal({

					title: 'Are you sure?',
					text: "This payment will be permanently delete in the System.",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes, Delete it!'

				}).then((result) => {

					if (result.value) { 

						fetch(API + '/permanent/delete/payment/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify({ id: id })
						}).then( data => { 

							return data.json();

						}).then( json => {

							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'Payment Deleted Successfully' , 
									'success'
								);

								this.getDeletedPayments();

							} else {

								this.$swal(
									'ERROR' ,
									'Something Went Wrong , Please Try Again.' , 
									'error'
								);

							}

						});
					}

				});

			} ,

			permanentDeleteAttachment (item) {

				let id         = item.attachment_id;
				let attachment = item.attachment;

				this.$swal({

					title: 'Are you sure?',
					text: "This attachment will be permanently delete in the System.",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes, Delete it!'

				}).then((result) => {

					if (result.value) { 

						fetch(API + '/permanent/delete/attachment/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify({ id: id , attachment: attachment })
						}).then( data => { 

							return data.json();

						}).then( json => {

							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'Attachment Deleted Successfully' , 
									'success'
								);

								this.getDeletedAttachments();

							} else {

								this.$swal(
									'ERROR' ,
									'Something Went Wrong , Please Try Again.' , 
									'error'
								);

							}

						});
					}

				});

			} ,

			permanentDeleteEmail (item) {
				let id         = item.email_id;

				this.$swal({

					title: 'Are you sure?',
					text: "This email will be permanently delete in the System.",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonColor: '#3085d6',
					cancelButtonColor: '#d33',
					confirmButtonText: 'Yes, Delete it!'

				}).then((result) => {

					if (result.value) { 

						fetch(API + '/permanent/delete/email/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify({ email_id: id })
						}).then( data => { 

							return data.json();

						}).then( json => {

							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'Email Deleted Successfully' , 
									'success'
								);

								this.getDeletedEmail();

							} else {

								this.$swal(
									'ERROR' ,
									'Something Went Wrong , Please Try Again.' , 
									'error'
								);

							}

						});
					}

				});

			} ,

			getDeletedServiceProviders () {

				fetch(API + "/get/deleted/service_providers/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.service_providers = json;
                    this.loading1          = false;
                });
            },

			getDeletedBills () {

				fetch(API + "/get/deleted/bills/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.bills    = json;
                    this.loading2 = false;
                });

			} ,

			getDeletedBillings () {

				fetch(API + "/get/deleted/billings/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.billings = json;
                    this.loading3 = false;
                });

			} ,

			getDeletedPayments () {

				fetch(API + "/get/deleted/payments/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.payments = json;
                    this.loading4 = false;
                });

			} ,

			getDeletedAttachments () {
				fetch(API + "/get/deleted/attachments/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.attachments = json;
                    this.loading5    = false;
                });
			} ,

			getDeletedEmail(){
				fetch(API + "/get/deleted/email/")
				.then(response => response.json())
				.then(data => {
					this.emails = data;
					this.loading6 = false;
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
			this.getDeletedServiceProviders();
			this.getDeletedBills();
			this.getDeletedBillings();
			this.getDeletedPayments();
			this.getDeletedAttachments();
			this.getDeletedEmail();
		} ,

	}
</script>