<template>
	<v-container fluid>
		<v-row>
			<v-col cols="12" sm="6">
				<v-card :dark="dark">
					<v-card-title> 
						Bill Paid & Unpaid 
					</v-card-title>

					<v-divider></v-divider>

					<v-card-text>
						<div>
							<v-chip color="error" dark>
								<v-avatar left>
									<v-icon>close</v-icon>
								</v-avatar>
								Unpaid 
							</v-chip>
							<v-chip color="teal darken-2" dark class="ml-2"> 
								<v-avatar left>
									<v-icon>check_circle</v-icon>
								</v-avatar>
								Paid 
							</v-chip>
						</div>

						<template
							v-if="filteredBills.length === 0">
							<h4 class="mt-3">
								No Record Found.
							</h4>
						</template>
						<template
							v-else>
							<v-text-field
								v-model="search"
								append-icon="search"
								label="Search Bill"
								:color="color">
							</v-text-field>
						</template>	

						<template>
							<div v-if="bills.length === 0"></div>
							<div v-else>
								<v-timeline>
									<v-timeline-item
										v-for="bill in filteredBills.slice((page1 - 1) * displayAmount1 , displayAmount1 * page1)"
										:key="bill.bill_id"
										:color="getStatus(bill.payment_status)">

										<template v-slot:opposite>
											<v-btn dark :to="'/view/' + bill.billing_id" :color="getStatus(bill.payment_status)"> 
												{{bill.bill_id}}
											</v-btn>
										</template>

										<v-card class="elavation-3">
											<v-card-title>
												<small>
													<b>{{ bill.account_name }}</b><br>
												</small> 
											</v-card-title>
											<v-card-text>
												<b>{{bill.due_date | moment('MMMM')}}</b><br>
												Billing: {{ bill.billing_id }}<br>	
											</v-card-text>
										</v-card>
									</v-timeline-item>
								</v-timeline>
							</div>
						</template>
					</v-card-text>

					<template>
						<div class="text-center" v-if="bills.length === 0">
						</div>
						<div v-else class="text-center">	
							<v-pagination
								v-model="page1"
								v-if="search === ''"
								:circle="circle"
								:color="color"
								class="mb-5"
								:length="Math.ceil(Object.keys(this.bills).length / displayAmount1)">
							</v-pagination>

							<v-pagination
								v-else
								disabled
								:circle="circle"
								class="mb-5"
								:length="Math.ceil(Object.keys(this.bills).length / displayAmount1)">
							</v-pagination>
						</div>
					</template>
				</v-card>
			</v-col>

			<v-col cols="12" sm="6">
				<v-card :dark="dark">
					<v-card-title> Billing Due Date </v-card-title>
					
					<v-divider></v-divider>
					
					<v-card-text>
						<template
							v-if="billings.length === 0">
							<h4>
								No Record Found.
							</h4>
						</template>

						<v-timeline
							v-else>
							<v-timeline-item
								v-for="billing in billings"
								:key="billing.billing_id"
								color="error"
								large>

								<template v-slot:opposite>
									<b>{{billing.day_left}}</b>
								</template>

								<v-card class="elavation-2">
									<v-card-title> 
										{{ billing.account_name }} 
									</v-card-title>
									<v-card-text>
										{{billing.due_date | moment("MMMM D, YYYY")}}
										<v-container>
											
											<v-row
												justify="end">
												<v-btn :color="color" dark :to="'/view/' + billing.billing_id"> View </v-btn>
											</v-row>
										</v-container>
									</v-card-text>
								</v-card>
							</v-timeline-item>
						</v-timeline>
					</v-card-text>
				</v-card>
			</v-col>
		</v-row>
	</v-container>
</template>

<script>
	import { API , token } from '../main'
	import moment_vue from 'moment'

	export default {
		data () {
			return {				
				/* Calendar Settings */
				start: moment_vue().format("YYYY-MM-DD") ,
				type: 'month',
				types: ['month', 'week', 'day', '4day'],
				weekday: [0, 1, 2, 3, 4, 5, 6],
				mode: 'stack',
				modes: ['stack', 'column'],
				weekdays: [
					{ text: 'Sun - Sat', value: [0, 1, 2, 3, 4, 5, 6] },
					{ text: 'Mon, Wed, Fri', value: [1, 3, 5] },
					{ text: 'Mon - Fri', value: [1, 2, 3, 4, 5] },
					{ text: 'Mon - Sun', value: [1, 2, 3, 4, 5, 6, 0] },
				],
				value: '',
				/* Calendar Settings */
				
				/* Pagination Settings */
				page1: 1 ,
				page2: 1 ,
				displayAmount1: 5 ,
				displayAmount2: 10 ,
				circle: true ,
				search: "" ,
				/* Pagination Settings */

				/* Data Array */
				bills: [] ,
				billings:[] ,
				/* Data Array */

				color: null , 
				switch1: true ,
				dark: false ,
			}
		} ,

		methods: {
			getBills () {
				fetch(API + "/get/bills/status/")
				.then(data => {
                    return data.json();
                })
                .then(json => {
					for(var a = 0; a < json.length; a++){
						let month = moment_vue(json[a].due_date).format("MM");
						let monthNow = moment_vue().format("MM");
						let year = moment_vue(json[a].due_date).format("YYYY");
						let yearNow = moment_vue().format("YYYY");
						if(month == monthNow){
							this.bills.push(json[a]);
						}else if((year < yearNow || month < monthNow) && json[a].payment_status == 0){
							this.bills.push(json[a]);
						}
					}
                });
			} ,

			getBillingDueDate(){
				fetch(API + "/get/billings/due/date")
				.then(response => response.json())
				.then(data => {
					for(var a = 0; a < data.length; a++){
						let year    = moment_vue(data[a].due_date).format("YYYY");
						let yearNow = moment_vue().format("YYYY");

						let todayDate = moment_vue().format("MMMM DD, YYYY");
						let dueDate   = moment_vue(data[a].due_date).format("MMMM DD, YYYY");
						let minusDay  = moment_vue(dueDate).diff(todayDate, 'days');
						if(year <= yearNow && minusDay <= 7){
							if(minusDay < 0){
								minusDay *= -1;
								minusDay = "Billing is due " + minusDay + " day/s ago pay it now!!";
							}else if(minusDay == 0){
								minusDay="This billing is due today";
							}else if(minusDay == 1){
								minusDay = "Billing is due tomorrow";
							}else if(minusDay == 6){
								minusDay = "Billing is due 1 week from now";
							}
							else{
								minusDay = "Billing is due " + minusDay + " days from now";
							}
							this.billings.push({ "billing_id" : data[a].billing_id, "bill_id": data[a].bill_id, "account_name": data[a].account_name, "due_date": data[a].due_date, "day_left": minusDay});
						}
					}
				});
			} ,

			getStatus (item) {
				let teal = "teal";
				let red  = "error";

				if (item === 0) {
					return red;
				} else {
					return teal;
				}
			} ,

			getActiveColor () {
				fetch(API + '/get/active/color/' + token)
				.then(response => response.json())
				.then(data => {
					this.color = data[0].color;
				});
			} ,
		} ,

		computed: {
			filteredBills() {
				return this.bills.filter( item => {
					return item.bill_id.toLowerCase().includes(this.search.toLowerCase())
				});
			} ,
		} , 

		beforeMount () {
			this.$emit('verify');
			this.getActiveColor();
			this.getBills();
			this.getBillingDueDate();
			this.getStatus();
		} ,
	}
</script>

<style lang="scss">
	$red1: #C62828;
	$red2: #E57373; 
	$teal1: #00695C;
	$teal2: #80CBC4;

	#card1 {
		background-image: linear-gradient(to right, $red1, $red2);  
	}

	#card2 {
		background-image: linear-gradient(to right, $teal1, $teal2);  
	}
	
	#card3 {
		background: #F5F5F5;
		color: #C62828;

		.cardText {
			color: #C62828;
		}
	}

	#card3:hover {
		background: #E0E0E0; 	
	}
</style>