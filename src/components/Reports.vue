<template>
	<v-container fluid>
		<v-card>
			<v-card-text>
				Under Maintenance
			
				<v-row>
					<v-col cols="12" sm="3">
						<v-card dark color="orange accent-4">
							<v-card-title>{{ billsCount }}</v-card-title>
							<v-card-text> Total Active Bills This Month </v-card-text>
						</v-card>		
					</v-col>

					<v-col cols="12" sm="3">
						<v-card dark color="indigo accent-2">
							<v-card-title>{{ billingsCount }}</v-card-title>
							<v-card-text>
								<small>
									Total Unpaid Billings This Month 
								</small>
							</v-card-text>
						</v-card>
					</v-col>

					<v-col cols="12" sm="3">
						<v-card dark color="teal">
							<v-card-title>{{ billingsSumPaid }}</v-card-title>
							<v-card-text> 
								<small>
									Total Amount Paid This Month 
								</small>
							</v-card-text>
						</v-card>
					</v-col>

					<v-col cols="12" sm="3">
						<v-card dark color="error">
							<v-card-title>{{ billingsSumUnpaid }}</v-card-title>
							<v-card-text> 
								<small>
									Total Amount Not Paid This Month 
								</small>
							</v-card-text>
						</v-card>
					</v-col>
					
				</v-row>
			</v-card-text>
		</v-card>
		
		<v-row>
			<v-col cols="12">
				<v-card>
					<v-card-title> Billings Table </v-card-title>
					<v-divider></v-divider>
					<v-card-text>
						<v-tabs
							v-model="tab"
							fixed-tabs
							:color="color">
							<v-tab href="#tab-1">
								By Month Year
							</v-tab>
							<v-tab href="#tab-2">
								By Date Range 
							</v-tab>
							<v-tab href="#tab-3">
								By Bill
							</v-tab>
						</v-tabs>

						<v-tabs-items v-model="tab">
							<v-tab-item
								value="tab-1">
								<v-row>
									<v-col cols="12" sm="5">
										<v-combobox
											v-model="month"
											item-text="text"
											item-value="value"
											:items="month_data"
											:color="color"
											:item-color="color"
											hide-details
											label="Month">
										</v-combobox>
									</v-col>

									<v-col cols="12" sm="5">
										<v-combobox
											v-model="year1"
											:items="year_data"
											:color="color"
											:item-color="color"
											hide-details
											label="Year">
										</v-combobox>
									</v-col>

									<v-col cols="12" sm="2">
										<v-btn :color="color" dark class="mt-3" block @click="getDisplay()"> Submit </v-btn>
									</v-col>
								</v-row>

								<div
									v-if="displayData.length === 0">
									
									<v-data-table 
										:headers="billings_header"
										:search="search"
										:items-per-page="10"
										class="mt-5 elevation-1">

										<template v-slot:item.billing_id="{ item }">
											<v-btn :color="color" text small :to="'/view/' + item.billing_id"> {{item.billing_id}} </v-btn>
										</template>

									</v-data-table>	
								</div>

								<div v-else>			
									<v-row>
										<v-col cols="12" sm="6">
											<v-text-field
												v-model="search"
												:color="color"
												label="Search Billing"
												hide-details>
											</v-text-field>
										</v-col>

										<v-col cols="12" sm="3">
											<v-text-field
												v-model="total_paid"
												:color="color"
												label="Total Paid"
												readonly
												hide-details>
											</v-text-field>
										</v-col>

										<v-col cols="12" sm="3">
											<v-text-field
												v-model="total_unpaid"
												:color="color"
												label="Total Unpaid"
												readonly
												hide-details>
											</v-text-field>
										</v-col>

										<v-col cols="12" sm="2">
											<v-btn :color="color" block dark @click="downloadPDFMY"> Download PDF </v-btn>
										</v-col>
									</v-row>					
									
									<v-data-table 
										:items="displayData"
										:headers="billings_header"
										:loading="loading"
										:search="search"
										:loading-text="loading_text"
										:items-per-page="10"
										class="mt-5 elevation-1">

										<template v-slot:item.billing_id="{ item }">
											<v-btn :color="color" text small :to="'/view/' + item.billing_id"> {{item.billing_id}} </v-btn>
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

										<template v-slot:item.billing_period="{ item }">
											<small>
												{{ item.billing_period_start | moment('MM-DD-YYYY') }} 
												<b> to </b>
												{{ item.billing_period_end | moment('MM-DD-YYYY') }}
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

										<template v-slot:item.created_by="{ item }">
											<small>
												{{ item.created_by }}
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

									</v-data-table>			
								</div>

							</v-tab-item>

							<v-tab-item
								value="tab-2">

								<v-row>
									<v-col cols="12" sm="5">
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
													label="Due Date:"
													readonly
													v-on="on"
													hide-details
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

									<v-col cols="12" sm="5">
										<v-menu
											:close-on-content-click="false"
											ref="startMenu2"
											v-model="startMenu2"
											:nudge-right="50"
											:return-value.sync="end_date"
											transition="scale-transition"
											min-width="290px"
											offset-y>

											<template v-slot:activator="{ on }">
												<v-text-field
													v-model="end_date"
													label="Due Date:"
													readonly
													v-on="on"
													hide-details
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
													@click="startMenu2 = false">
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

									<v-col cols="12" sm="2">
										<v-btn :color="color" dark class="mt-3" block @click="getDisplayRange()"> Submit </v-btn>
									</v-col>
								</v-row>

								<div
									v-if="displayDataRange.length === 0">
									
									<v-data-table 
										:headers="billings_header"
										:search="search"
										:items-per-page="10"
										class="mt-5 elevation-1">

										<template v-slot:item.billing_id="{ item }">
											<v-btn :color="color" text small :to="'/view/' + item.billing_id"> {{item.billing_id}} </v-btn>
										</template>

									</v-data-table>	
								</div>

								<div v-else>			
									<v-row>
										<v-col cols="12" sm="6">
											<v-text-field
												v-model="range_search"
												:color="color"
												label="Search Billing"
												hide-details>
											</v-text-field>
										</v-col>

										<v-col cols="12" sm="3">
											<v-text-field
												v-model="range_total_paid"
												:color="color"
												label="Total Paid"
												readonly
												hide-details>
											</v-text-field>
										</v-col>

										<v-col cols="12" sm="3">
											<v-text-field
												v-model="range_total_unpaid"
												:color="color"
												label="Total Unpaid"
												readonly
												hide-details>
											</v-text-field>
										</v-col>

										<v-col cols="12" sm="2">
											<v-btn :color="color" block dark @click="downloadPDFRange"> Download PDF </v-btn>
										</v-col>
									</v-row>					
									
									<v-data-table 
										:items="displayDataRange"
										:headers="billings_header"
										:loading="loading"
										:search="range_search"
										:loading-text="loading_text"
										:items-per-page="10"
										class="mt-5 elevation-1">

										<template v-slot:item.billing_id="{ item }">
											<v-btn :color="color" text small :to="'/view/' + item.billing_id"> {{item.billing_id}} </v-btn>
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

										<template v-slot:item.billing_period="{ item }">
											<small>
												{{ item.billing_period_start | moment('MM-DD-YYYY') }} 
												<b> to </b>
												{{ item.billing_period_end | moment('MM-DD-YYYY') }}
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

										<template v-slot:item.created_by="{ item }">
											<small>
												{{ item.created_by }}
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

									</v-data-table>			
								</div>
							</v-tab-item>

							<v-tab-item
								value="tab-3">
								<v-row>
									<v-col cols="12" sm="5">
										<v-combobox
											v-model="account_name"
											:items="bills"
											label="Account Name"
											item-text="account_name"
											item-value="bill_id"
											:color="color"
											:item-color="color"
											hide-details>
										</v-combobox>
									</v-col>
									<v-col cols="12" sm="5">
										<v-combobox
											v-model="year2"
											:items="year_data"
											:color="color"
											:item-color="color"
											hide-details
											label="Year">
										</v-combobox>
									</v-col>

									<v-col cols="12" sm="2">
										<v-btn :color="color" dark class="mt-3" block @click="getDisplayByBill"> Submit </v-btn>
									</v-col>
								</v-row>

								<div
									v-if="displayDataByBill.length === 0">
									
									<v-data-table 
										:headers="billings_header"
										:search="search"
										:items-per-page="10"
										class="mt-5 elevation-1">

										<template v-slot:item.billing_id="{ item }">
											<v-btn :color="color" text small :to="'/view/' + item.billing_id"> {{item.billing_id}} </v-btn>
										</template>

									</v-data-table>	
								</div>

								<div v-else>	
									<v-row>
										<v-col cols="12" sm="6">
											<v-text-field
												v-model="by_bill_search"
												:color="color"
												label="Search Billing"
												hide-details>
											</v-text-field>
										</v-col>

										<v-col cols="12" sm="3">
											<v-text-field
												v-model="by_bill_total_paid"
												:color="color"
												label="Total Paid"
												readonly
												hide-details>
											</v-text-field>
										</v-col>

										<v-col cols="12" sm="3">
											<v-text-field
												v-model="by_bill_total_unpaid"
												:color="color"
												label="Total Unpaid"
												readonly
												hide-details>
											</v-text-field>
										</v-col>

										<v-col cols="12" sm="2">
											<v-btn :color="color" block dark @click="downloadPDF"> Download PDF </v-btn>
										</v-col>
									</v-row>					

									<v-data-table 
										:items="displayDataByBill"
										:headers="billings_header"
										:loading="loading"
										:search="by_bill_search"
										:loading-text="loading_text"
										:items-per-page="10"
										class="mt-5 elevation-1">

										<template v-slot:item.billing_id="{ item }">
											<v-btn :color="color" text small :to="'/view/' + item.billing_id"> {{item.billing_id}} </v-btn>
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

										<template v-slot:item.billing_period="{ item }">
											<small>
												{{ item.billing_period_start | moment('MM-DD-YYYY') }} 
												<b> to </b>
												{{ item.billing_period_end | moment('MM-DD-YYYY') }}
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

										<template v-slot:item.created_by="{ item }">
											<small>
												{{ item.created_by }}
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

									</v-data-table>			
								</div>
							</v-tab-item>
						</v-tabs-items>
					</v-card-text>
				</v-card>
			</v-col>
		</v-row>

		<!-- <v-row>
			<v-col cols="12">
				<v-card>
					<v-sheet height="64">
						<v-toolbar flat color="white">
							<v-btn @click="setToday"> Today </v-btn>
							<v-btn fab text small color="grey darken-2" @click="prev">
								<v-icon small>mdi-chevron-left</v-icon>
							</v-btn>
							<v-btn fab text small color="grey darken-2" @click="next">
								<v-icon small>mdi-chevron-right</v-icon>
							</v-btn>
							<v-toolbar-title>{{ title }}</v-toolbar-title>
							<v-spacer></v-spacer>
							<v-menu bottom right>
								<template v-slot:activator="{ on }">
									<v-btn
										outlined
										color="grey darken-2"
										v-on="on">
										<span>{{ typeToLabel[type] }}</span>
										<v-icon right>mdi-menu-down</v-icon>
									</v-btn>
								</template>
								<v-list>
									<v-list-item @click="type = 'day'">
										<v-list-item-title>Day</v-list-item-title>
									</v-list-item>
									<v-list-item @click="type = 'week'">
										<v-list-item-title>Week</v-list-item-title>
									</v-list-item>
									<v-list-item @click="type = 'month'">
										<v-list-item-title>Month</v-list-item-title>
									</v-list-item>
									<v-list-item @click="type = '4day'">
										<v-list-item-title>4 days</v-list-item-title>
									</v-list-item>
								</v-list>
							</v-menu>
						</v-toolbar>
		
						<v-sheet height="600">
							<v-calendar
								ref="calendar"
								v-model="focus"
								color="primary"
								:events="events"
								:event-color="getEventColor"
								:now="today"
								:type="type"
								@click:event="showEvent"
								@click:more="viewDay"
								@click:date="viewDay"
								@change="updateRange"
								>
							</v-calendar>
							<v-menu
								v-model="selectedOpen"
								:close-on-content-click="false"
								:activator="selectedElement"
								offset-x
								>
								<v-card
									color="grey lighten-4"
									min-width="350px"
									flat
									>
									<v-toolbar
									:color="selectedEvent.color"
									dark
									>
										<v-btn icon>
											<v-icon>mdi-pencil</v-icon>
										</v-btn>
		
										<v-toolbar-title v-html="selectedEvent.name"></v-toolbar-title>
										<v-spacer></v-spacer>
		
										<v-btn icon>
											<v-icon>mdi-heart</v-icon>
										</v-btn>
		
										<v-btn icon>
											<v-icon>mdi-dots-vertical</v-icon>
										</v-btn>
									</v-toolbar>
									<v-card-text>
										<span v-html="selectedEvent.details"></span>
									</v-card-text>
									<v-card-actions>
										<v-btn
										text
										color="secondary"
										@click="selectedOpen = false"
										>
										Cancel
										</v-btn>
									</v-card-actions>
								</v-card>
							</v-menu>
							</v-sheet>
					</v-sheet>
				</v-card>
			</v-col>
		</v-row> -->
	</v-container>
</template>

<script>
	import { API , token } from '../main' 
	import moment from 'moment' 
	import jsPDF from 'jspdf'
	import 'jspdf-autotable'

	export default {
		data () {
			return {
				/* Calendar */
				focus: '',
				type: 'month',
				typeToLabel: {
					month: 'Month',
					week: 'Week',
					day: 'Day',
					'4day': '4 Days',
				},
				start: null,
				end: null,
				selectedEvent: {},
				selectedElement: null,
				selectedOpen: false,
				events: [],
				colors: ['blue', 'indigo', 'deep-purple', 'cyan', 'green', 'orange', 'grey darken-1'],
				names: ['Meeting', 'Holiday', 'PTO', 'Travel', 'Event', 'Birthday', 'Conference', 'Party'],

				tab: null ,
				on: false ,
				displaySearch: false ,
				search: "" ,
				range_search: "" ,
				by_bill_search: "" ,
				switch1: true ,
				dark: false ,

				startMenu1: false ,
				startMenu2: false ,
				start_date: moment().format("YYYY-MM-DD") ,
				end_date: moment().format("YYYY-MM-DD") ,

				/* Count */
				billsCount: 0 ,
				billingsCount: 0 ,
				paymentsCount: 0 ,
				attachmentCount: 0 ,
				total_paid: 0 ,
				total_unpaid: 0 ,
				range_total_paid: 0 ,
				range_total_unpaid: 0 ,
				by_bill_total_paid: 0 ,
				by_bill_total_unpaid: 0 ,

				/* Sum */
				billingsSumPaid: 0 ,
				billingsSumUnpaid: 0 ,

				month: "" ,
				year1: "" ,
				year2: "" ,
				account_name: "" ,

				bills: [] ,
				displayData: [] ,
				displayDataRange: [] ,
				displayDataByBill: [] ,

				/* Datatables Settings */
				loading: true ,
				loading_text: "Loading Data ... Please Wait " ,
				/* Datatables Settings */

				month_data: [ 
					{
						text: "January" ,
						value: "01" ,	
					} ,
					{
						text: "February" ,
						value: "02" ,
					} , 
					{
						text: "March" ,
						value: "03" ,
					} ,
					{
						text: "April" ,
						value: "04" , 
					} , 
					{
						text: "May" ,
						value: "05" ,
					} , 
					{
						text: "June" ,
						value: "06" , 
					} , 
					{
						text: "July" ,
						value: "07" ,
					} , 
					{
						text: "August" ,
						value: "08" ,
					} , 
					{
						text: "September" ,
						value: "09" ,
					} , 
					{
						text: "October" ,
						value: "10" ,  
					} , 
					{
						text: "November" ,
						value: "11", 
					} , 
					{
						text: "December" ,
						value: "12" , 
					}
				] ,

				year_data: [ 2015 , 2016 , 2017 , 2018 , 2019 , 2020 , 2021 , 2022 , 2023 , 2024 , 2025 ] ,

				/* Datatables Header */

				billings_header: [
					{
						text: "Billing" ,
						value: "billing_id" ,
						align: "left" 
					} ,
					{
						text: "SOA Number" ,
						value: "soa_number" ,
					} ,
					{
						text: "Account Name" ,
						value: "account_name" ,
					} ,
					{
						text: "Account Number" ,
						value: "account_number" ,
					} ,
					{
						text: "Billing Period" ,
						value: "billing_period" ,
					} ,
					{
						text: "Due Date" ,
						value: "due_date" ,
					} ,
					{
						text: "Amount" ,
						value: "amount" ,
					} ,
					{
						text: "Created By" ,
						value: "created_by"
					} ,
					{
						text: "Payment Status" ,
						value: "payment_status" ,
						align: "center" ,
					}
				] ,
				/* Datatables Header */
				color: null ,
			}
		} ,

		methods: {
			
			getCountBills () {
				fetch(API + "/get/counted/bills/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.billsCount = json[0].billsCount;
                });
			} ,

			getCountBillings () {
				fetch(API + "/get/counted/billings/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.billingsCount = json[0].billingsCount;
                });
			} , 

			getDisplay () {

				let month = this.month.value;
				let year  = this.year1;

				if (!month || !year) {

					this.$swal(
						'WARNING' , 
						'Month or year field is required!' , 
						'warning'
					);

                } else {

					fetch(API + "/get/display/" + month + "/" + year)
					.then(data => {
						return data.json();
					})
					.then(json => {

						if (!month || !year) {

							this.$swal(
								'WARNING' , 
								'Month or year field is required!' , 
								'warning'
							);

						} else { 

							if (json.length === 0) {

								this.displayData   = json;
								this.loading       = false;

							} else {

								this.displayData   = json;
								this.loading       = false;
								this.displaySearch = true;
							}

						}

					});

					fetch(API + "/get/total/paid/" + month + "/" + year)
					.then(data => {
						return data.json();
					})
					.then(json => { 

						if (!month || !year) {

							this.$swal(
								'WARNING' , 
								'Month or year field is required!' , 
								'warning'
							);

						} else { 

							this.total_paid = json.sum_paid;
						
						}

					});


					fetch(API + "/get/total/unpaid/" + month + "/" + year)
					.then(data => {
						return data.json();
					})
					.then(json => { 

						if (!month || !year) {

							this.$swal(
								'WARNING' , 
								'Month or year field is required!' , 
								'warning'
							);

						} else { 

							this.total_unpaid = json.sum_unpaid;
						
						}

					});
				}		

			} ,

			getDisplayRange() {
				let start_date = this.start_date;
				let end_date   = this.end_date;

				if (!start_date || !end_date) {

					this.$swal(
						'WARNING' , 
						'Start and end date field is required!' , 
						'warning'
					);

                } else {

                    fetch(API + "/get/display/range/" + start_date + "/" + end_date)
					.then(data => {
						return data.json();
					})
					.then(json => {
						window.console.log(json);

						if (!start_date || !end_date) {

							this.$swal(
								'WARNING' , 
								'Month or year field is required!' , 
								'warning'
							);

						} else { 

							if (json.length === 0) {

								this.displayDataRange = json;
								this.loading          = false;

							} else {

								this.displayDataRange = json;
								this.loading          = false;
								this.displaySearch    = true;
							}

						}

					});


					fetch(API + "/get/display/range/paid/" + start_date + "/" + end_date)
					.then(data => {
						return data.json();
					})
					.then(json => { 
						this.range_total_paid = json.range_total_paid;
					});


					fetch(API + "/get/display/range/unpaid/" + start_date + "/" + end_date)
					.then(data => {
						return data.json();
					})
					.then(json => { 
						this.range_total_unpaid = json.range_total_unpaid;

					});

                }
			} ,

			getDisplayByBill () {

				let account_name = this.account_name.bill_id;
				let year         = this.year2;

				if (!account_name || !year) {

					this.$swal(
						'WARNING' , 
						'Account Name or year field is required!' , 
						'warning'
					);

                } else {

                    fetch(API + "/get/display/by/bill/" + account_name + "/" + year)
					.then(data => {
						return data.json();
					})
					.then(json => {

						if (!account_name || !year) {

							this.$swal(
								'WARNING' , 
								'Month or year field is required!' , 
								'warning'
							);

						} else { 

							if (json.length === 0) {

								this.displayDataByBill = json;
								this.loading           = false;

							} else {

								this.displayDataByBill = json;
								this.loading           = false;
								this.displaySearch     = true;
							}

						}

					});

					fetch(API + "/get/display/by/bill/paid/" + account_name + "/" + year)
					.then(data => {
						return data.json();
					})
					.then(json => { 
						this.by_bill_total_paid = json.totalSumBillingsPaid;
					});


					fetch(API + "/get/display/by/bill/unpaid/" + account_name + "/" + year)
					.then(data => {
						return data.json();
					})
					.then(json => { 
						this.by_bill_total_unpaid = json.totalSumBillingsUnpaid;

					});

                }

			} ,

			downloadPDFMY () {
				let result         = this.displayData;
				let i              = 0;
				let billing        = "";
				let name           = "";
				let soa_number     = "";
				let account_number = "";
				let due_date       = "";
				let amount         = "";
				let status         = "";
				let payment        = "";
				let body           = [];
				let date           = new Date();
				let pdfName        = 'Billings Monitoring ' + (date.getMonth()+1)+'-'+date.getDate()+'-'+date.getFullYear();
				let doc            = new jsPDF('landscape');

				for (i; i < result.length; i++) {
					billing        = result[i].billing_id;
					name           = result[i].account_name;
					soa_number     = result[i].soa_number;
					account_number = result[i].account_number;
					due_date       = moment(result[i].due_date).format("YYYY-MM-DD");
					amount         = result[i].amount;
					status         = result[i].payment_status;
					
					if (status === 1) {
						payment = "Paid";
					} else {
						payment = "Unpaid";
					}
					
					body.push([[billing] , [name] , [soa_number] , [account_number] , [due_date] , [amount] , [payment]])
				}

				doc.setFontSize(20);
				doc.text('Billings Monitoring' , 15 , 15);

				doc.autoTable({
					margin: { top: 25 } ,
					format: 'legal' ,		
					theme: 'striped' ,
					head: [[ 'Billing' , 'Name' ,  'SOA Number' , 'Account Number' , 'Due Date' , 'Amount' , 'Payment Status']] ,
					body: body ,
				});
				doc.save(pdfName + '.pdf');
			} ,

			downloadPDFRange () {
				let result         = this.displayDataRange;
				let i              = 0;
				let billing        = "";
				let name           = "";
				let soa_number     = "";
				let account_number = "";
				let due_date       = "";
				let amount         = "";
				let status         = "";
				let payment        = "";
				let body           = [];
				let date           = new Date();
				let pdfName        = 'Billings Monitoring ' + (date.getMonth()+1)+'-'+date.getDate()+'-'+date.getFullYear();
				let doc            = new jsPDF('landscape');

				for (i; i < result.length; i++) {
					billing        = result[i].billing_id;
					name           = result[i].account_name;
					soa_number     = result[i].soa_number;
					account_number = result[i].account_number;
					due_date       = moment(result[i].due_date).format("YYYY-MM-DD");
					amount         = result[i].amount;
					status         = result[i].payment_status;
					
					if (status === 1) {
						payment = "Paid";
					} else {
						payment = "Unpaid";
					}
					
					body.push([[billing] , [name] , [soa_number] , [account_number] , [due_date] , [amount] , [payment]])
				}

				doc.setFontSize(20);
				doc.text('Billings Monitoring' , 15 , 15);

				doc.autoTable({
					margin: { top: 25 } ,
					format: 'legal' ,		
					theme: 'striped' ,
					head: [[ 'Billing' , 'Name' ,  'SOA Number' , 'Account Number' , 'Due Date' , 'Amount' , 'Payment Status']] ,
					body: body ,
				});
				doc.save(pdfName + '.pdf');
			} ,

			downloadPDF () {
				let result         = this.displayDataByBill;
				let i              = 0;
				let billing        = "";
				let name           = "";
				let soa_number     = "";
				let account_number = "";
				let due_date       = "";
				let amount         = "";
				let status         = "";
				let payment        = "";
				let body           = [];
				let date           = new Date();
				let pdfName        = 'Billings Monitoring ' + (date.getMonth()+1)+'-'+date.getDate()+'-'+date.getFullYear();
				let doc            = new jsPDF('landscape');

				for (i; i < result.length; i++) {
					billing        = result[i].billing_id;
					name           = result[i].account_name;
					soa_number     = result[i].soa_number;
					account_number = result[i].account_number;
					due_date       = moment(result[i].due_date).format("YYYY-MM-DD");
					amount         = result[i].amount;
					status         = result[i].payment_status;
					
					if (status === 1) {
						payment = "Paid";
					} else {
						payment = "Unpaid";
					}
					
					body.push([[billing] , [name] , [soa_number] , [account_number] , [due_date] , [amount] , [payment]])
				}

				doc.setFontSize(20);
				doc.text('Billings Monitoring' , 15 , 15);

				doc.autoTable({
					margin: { top: 25 } ,
					format: 'legal' ,		
					theme: 'striped' ,
					head: [[ 'Billing' , 'Name' ,  'SOA Number' , 'Account Number' , 'Due Date' , 'Amount' , 'Payment Status']] ,
					body: body ,
				});
				doc.save(pdfName + '.pdf');
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

			getSumBillingsPaid () {
				fetch(API + "/get/sum/billings/paid/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.billingsSumPaid = json.totalSumBillingsPaid.toFixed(2);
                });
			} , 

			getSumBillingsUnpaid () {
				fetch(API + "/get/sum/billings/unpaid/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.billingsSumUnpaid = json.totalSumBillingsUnpaid.toFixed(2);
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
			/* Count */
			this.getCountBills();
			this.getCountBillings();

			/* Sum */
			this.getSumBillingsPaid();
			this.getSumBillingsUnpaid();

			this.getBills();
		} ,

		computed: {
			title () {
				const { start, end } = this
				if (!start || !end) {
					return ''
				}

				const startMonth = this.monthFormatter(start)
				const endMonth = this.monthFormatter(end)
				const suffixMonth = startMonth === endMonth ? '' : endMonth

				const startYear = start.year
				const endYear = end.year
				const suffixYear = startYear === endYear ? '' : endYear

				const startDay = start.day + this.nth(start.day)
				const endDay = end.day + this.nth(end.day)

				switch (this.type) {
					case 'month':
					return `${startMonth} ${startYear}`
					case 'week':
					case '4day':
					return `${startMonth} ${startDay} ${startYear} - ${suffixMonth} ${endDay} ${suffixYear}`
					case 'day':
					return `${startMonth} ${startDay} ${startYear}`
				}
				return ''
			},

			monthFormatter () {
				return this.$refs.calendar.getFormatter({
					timeZone: 'UTC', month: 'long',
				})
			},
		}
	}	
</script>