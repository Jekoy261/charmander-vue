<template>
	<v-container>
		<v-expansion-panels
			v-model="panel"
			multiple>
			<v-expansion-panel>
				<div v-for="(billing , index) in billings"
					:key="index">
					<v-expansion-panel-header> Billing Details </v-expansion-panel-header>
					<v-expansion-panel-content>
						<v-container>
							<div
								v-if="edit_billing_p">
								<small>
									
								<p>
									<b>Billing: </b> {{ billing.billing_id }}
								</p>
								<p>
									<b>SOA Number:</b> {{billing.soa_number}}
								</p>
								<p>
									<b>Account Name:</b> {{billing.account_name}}
								</p>
								<p>
									<b>Billing Period:</b>
									<br>
									<b class="ml-5"> Start Date: </b>{{billing.billing_period_start | moment('MM-DD-YYYY') }} <b> - End Date: </b> {{billing.billing_period_end | moment('MM-DD-YYYY') }}
								</p>
								<p>
									<b>Due Date:</b> {{billing.due_date | moment('MM-DD-YYYY') }}
								</p>
								<p>
									<b>Amount:</b> {{billing.amount}}
								</p>
								<p>
									<b>Date Received:</b> {{billing.bill_received_date | moment('MM-DD-YYYY') }}
								</p>
								<p>
									<b>Created By:</b> {{billing.created_by}}
								</p>
								<p>
									<b>Remarks:</b> {{billing.remarks}}
								</p>
								</small>
									
								<v-btn :color="color" dark @click="editBilling(billing)"> Edit </v-btn>									
							</div>
							<div
								v-if="edit_billing_text_field">
								<v-input
									v-model="edit_billing_id"
									hideDetails>
								</v-input>
								<v-row>
									<v-col cols="12" sm="4">
										<v-select
											v-model="edit_bill_id"
											label="Service Provider"
											item-text="account_name"
											item-value="bill_id"
											:items="bills"
											@change="editAccountChange(edit_bill_id)"
											:color="color"
											:item-color="color">
										</v-select>
										
										<v-menu
											ref="startMenu13"
											v-model="startMenu13"
											:close-on-content-click="false"
											:return-value.sync="new_billing_period_start"
											transition="scale-transition"
											min-width="290px"
											offset-y>

											<template v-slot:activator="{ on }">
												<v-text-field
													v-model="edit_billing_period_start"
													label="Billing Period: Start Date"
													readonly
													v-on="on"
													:color="color"
												></v-text-field>
											</template>
											
											<v-date-picker
												v-model="edit_billing_period_start"
												no-title
												scrollable>
												<v-btn :color="color" text @click="startMenu13 = false"> Cancel </v-btn>
												<v-btn :color="color" text @click="save13"> OK </v-btn>
											</v-date-picker>
										</v-menu>

										<v-text-field
											v-model="edit_billing_amount"
											type="number"
											label="Amount"
											:color="color">
										</v-text-field>
									</v-col>

									<v-col cols="12" sm="4">
										<v-text-field
											readonly
											v-model="edit_account_number"
											label="Account Number"
											:color="color">
										</v-text-field>

										<v-menu
											v-model="startMenu4"
											:close-on-content-click="false"
											:return-value.sync="new_billing_period_end"
											transition="scale-transition"
											min-width="290px"
											offset-y>

											<template v-slot:activator="{ on }">
												<v-text-field
													v-model="edit_billing_period_end"
													label="Billing Period: End Date"
													ref="startMenu4"
													readonly
													v-on="on"
													:color="color"
												></v-text-field>
											</template>
											
											<v-date-picker
												v-model="edit_billing_period_end"
												no-title
												scrollable>
												<v-spacer></v-spacer>
												<v-btn :color="color" text @click="startMenu4 = false">
													Cancel
												</v-btn>
												<v-btn :color="color" text @click="save4">
													OK
												</v-btn>
											</v-date-picker>
										</v-menu>

										<v-menu
											ref="startMenu6"
											v-model="startMenu6"
											:close-on-content-click="false"
											:return-value.sync="new_date_recieved"
											transition="scale-transition"
											min-width="290px"
											offset-y>

											<template v-slot:activator="{ on }">
												<v-text-field
													v-model="edit_date_received"
													label="Date Received"
													readonly
													v-on="on"
													:color="color"
												></v-text-field>
											</template>
											
											<v-date-picker
												v-model="edit_date_received"
												no-title
												scrollable>
												<v-spacer></v-spacer>
												<v-btn :color="color" text @click="startMenu6 = false">
													Cancel
												</v-btn>
												<v-btn :color="color" text @click="save6">
													OK
												</v-btn>
											</v-date-picker>
										</v-menu>
									</v-col>
									
									<v-col cols="12" sm="4">
										<v-text-field
											v-model="edit_soa_number"
											type="text"
											label="SOA Number"
											:color="color"
											maxlength="20">
										</v-text-field>

										<v-menu
											ref="startMenu5"
											v-model="startMenu5"
											:close-on-content-click="false"
											:return-value.sync="new_due_date"
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
												<v-btn :color="color" text @click="startMenu5 = false">
													Cancel
												</v-btn>
												<v-btn :color="color" text @click="save5">
													OK
												</v-btn>
											</v-date-picker>
										</v-menu>

										<v-text-field
											v-model="edit_billing_created_by"
											type="text"
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

								<v-btn :color="color" dark @click="updateBilling"> Update </v-btn>
								<v-btn :color="color" dark class="ml-2" @click="cancelEditBilling"> Cancel </v-btn>
							</div>
						</v-container>
					</v-expansion-panel-content>
				</div>
			</v-expansion-panel>

			<v-expansion-panel>
				<v-expansion-panel-header>
					Payment Details 
				</v-expansion-panel-header>
					<v-expansion-panel-content>
						<template v-if="payments.length === 0">
							<v-btn :color="color" dark @click="add_payment_dialog = !add_payment_dialog"> Add Payment </v-btn>
						</template>
						<template v-else>
							<v-btn disabled> Add Payment </v-btn>
						</template>

						<v-dialog
							v-model="add_payment_dialog" max-width="700px" persistent>
							<v-card>
								<v-tabs
									v-model="tab"
									:background-color="color"
									centered
									dark
									icon-and-text>
									<v-tabs-slider></v-tabs-slider>
								
									<v-tab href="#tab-1">
										Cash
										<v-icon>attach_money</v-icon>
									</v-tab>

									<v-tab href="#tab-2">
										Cheque
										<v-icon>account_balance_wallet</v-icon>
									</v-tab>
								</v-tabs>

								<v-tabs-items 
									v-model="tab">
									<v-tab-item
										:value="'tab-1'">
										<v-card>
											<v-card-text>
												<v-container>
													<v-row>
														<v-col cols="12" sm="6">
															<v-text-field
																v-model="cash_voucher_number"
																type="text"
																label="Voucher Number"
																:color="color"
																maxlength="20">
															</v-text-field>
														</v-col>

														<v-col cols="12" sm="6">
															<v-menu
																ref="startMenu1"
																v-model="startMenu1"
																:close-on-content-click="false"
																:return-value.sync="cash_voucher_date"
																transition="scale-transition"
																min-width="290px"
																offset-y>

																<template v-slot:activator="{ on }">
																	<v-text-field
																		v-model="cash_voucher_date"
																		label="Voucher Date"
																		readonly
																		v-on="on"
																		:color="color"
																	></v-text-field>
																</template>
																
																<v-date-picker
																	v-model="cash_voucher_date"
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
																		@click="$refs.startMenu1.save(cash_voucher_date)">
																		OK
																	</v-btn>
																</v-date-picker>
															</v-menu>
														</v-col>

														<v-col cols="12" sm="12" style="margin-top: -27px; margin-bottom: -27px;">
															<v-text-field
																v-model="cash_amount"
																type="number"
																label="Amount"
																:color="color"
																readonly>
															</v-text-field>
														</v-col>


														<v-col cols="12" sm="6">
															<v-text-field
																v-model="cash_accountable_person"
																type="text"
																label="Accountable Person"
																:color="color">
															</v-text-field>

															<v-text-field
																v-model="cash_received_by"
																type="text"
																label="Received By"
																:color="color">
															</v-text-field>
														</v-col>

														<v-col cols="12" sm="6">
															<v-text-field
																v-model="cash_prepared_by"
																type="text"
																label="Prepared By"
																:color="color">
															</v-text-field>

															<v-text-field
																v-model="cash_created_by"
																type="text"
																label="Created By"
																readonly
																:color="color">
															</v-text-field>
														</v-col>

													</v-row>
													<v-row
														justify="end">
														<v-btn color="primary" @click="addPaymentCash"> Add </v-btn>
														<v-btn color="error" class="ml-2 mr-3" @click="add_payment_dialog = !add_payment_dialog"> Close </v-btn>
													</v-row>
												</v-container>
											</v-card-text>
										</v-card>
									</v-tab-item>

									<v-tab-item
										value="tab-2">
										<v-card flat>
											<v-card-text>
												<v-container>
													<v-row>
														<v-col cols="12" sm="6">
															<v-text-field
																v-model="cheque_voucher_number"
																type="text"
																label="Voucher Number"
																:color="color"
																maxlength="20">
															</v-text-field>

															<v-text-field
																v-model="cheque_number"
																type="text"
																label="Cheque Number"
																:color="color"
																maxlength="20">
															</v-text-field>

															<v-menu
																ref="startMenu2"
																v-model="startMenu2"
																:close-on-content-click="false"
																:return-value.sync="cheque_date"
																transition="scale-transition"
																min-width="290px"
																offset-y>

																<template v-slot:activator="{ on }">
																	<v-text-field
																		v-model="cheque_date"
																		label="Cheque Date"
																		readonly
																		v-on="on"
																		:color="color"
																	></v-text-field>
																</template>
																
																<v-date-picker
																	v-model="cheque_date"
																	no-title
																	scrollable
																	>
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
																		@click="$refs.startMenu2.save(cheque_date)">
																		OK
																	</v-btn>
																</v-date-picker>
															</v-menu>
	
															<v-text-field
																v-model="cheque_accountable_person"
																type="text"
																label="Accountable Person"
																:color="color">
															</v-text-field>

															<v-text-field
																v-model="cheque_prepared_by"
																type="text"
																label="Prepared By"
																:color="color">
															</v-text-field>
														</v-col>	

														<v-col cols="12" sm="6">
															<v-menu
																ref="startMenu11"
																v-model="startMenu11"
																:close-on-content-click="false"
																:return-value.sync="cheque_voucher_date"
																transition="scale-transition"
																min-width="290px"
																offset-y>

																<template v-slot:activator="{ on }">
																	<v-text-field
																		v-model="cheque_voucher_date"
																		label="Voucher Date"
																		readonly
																		v-on="on"
																		:color="color"
																	></v-text-field>
																</template>
																
																<v-date-picker
																	v-model="cheque_voucher_date"
																	no-title
																	scrollable>
																	<v-spacer></v-spacer>
																	<v-btn
																		:color="color"
																		text
																		@click="startMenu11 = false">
																		Cancel
																	</v-btn>
																	<v-btn
																		:color="color"
																		text
																		@click="$refs.startMenu11.save(cheque_voucher_date)">
																		OK
																	</v-btn>
																</v-date-picker>
															</v-menu>

															<v-text-field
																v-model="cheque_amount"
																type="number"
																label="Amount"
																:color="color"
																readonly>
															</v-text-field>

															<v-text-field
																v-model="cheque_bank"
																type="text"
																label="Bank"
																:color="color">
															</v-text-field>
															
															<v-text-field
																v-model="cheque_received_by"
																type="text"
																label="Received By"
																:color="color">
															</v-text-field>
															
															<v-text-field
																v-model="cheque_created_by"
																type="text"
																readonly
																label="Created By"
																:color="color">
															</v-text-field>

														</v-col>	

													</v-row>
													<v-row
														justify="end">
														<v-btn color="primary" @click="addPaymentQheque"> Add </v-btn>
														<v-btn color="error" class="ml-2 mr-3" @click="add_payment_dialog = !add_payment_dialog"> Close </v-btn>
													</v-row>
												</v-container>	
											</v-card-text>
										</v-card>
									</v-tab-item>		
								</v-tabs-items>
								
							</v-card>
						</v-dialog>
						
						<div
							v-for="(payment , index) in payments"
							:key="index">
							<v-card-text>
								<v-container>
									<div v-if="payment.payment_type === 0">
										<div
											v-if="cash_edit_payment_p">
											<p>
												<b>Voucher Number:</b> {{ payment.voucher_number }}
											</p>
											<p>
												<b>Voucher Date:</b> {{ payment.voucher_date | moment('MM-DD-YYYY') }}
											</p>
											<p>
												<b>Amount:</b> {{ payment.amount }}
											</p>
											<p>
												<b>Accountable Person:</b> {{ payment.accountable_person }}
											</p>
											<p>
												<b>Prepared By:</b> {{ payment.prepared_by }}
											</p>
											<p>
												<b>Received By:</b> {{ payment.received_by }}
											</p>
											<p>
												<b>Created By:</b> {{ payment.created_by }}
											</p>
											<v-btn :color="color" dark v-if="cash_edit_payment_p" @click="editPaymentCash(payment)"> Edit </v-btn>
											<v-btn :color="color" dark v-if="cash_edit_payment_p" @click="deletePayment(payment)" class="ml-2"> Delete </v-btn>
										</div>
														
										<div
											v-if="cash_edit_payment_text_field">

											<v-input
												v-model="cash_edit_bill_payment_id"
												hideDetails>
											</v-input>

											<v-row>
												<v-col cols="12" sm="6">
													<v-text-field
														v-model="cash_edit_voucher_number"
														type="text"
														label="Voucher Number"
														:color="color"
														maxlength="20">
													</v-text-field>
												</v-col>

												<v-col cols="12" sm="6">
													<v-menu
														ref="startMenu7"
														v-model="startMenu7"
														:close-on-content-click="false"
														:return-value.sync="new_voucher_date"
														transition="scale-transition"
														min-width="290px"
														offset-y>

														<template v-slot:activator="{ on }">
															<v-text-field
																v-model="cash_edit_voucher_date"
																label="Voucher Date"
																readonly
																v-on="on"
																:color="color"
															></v-text-field>
														</template>
														
														<v-date-picker
															v-model="cash_edit_voucher_date"
															no-title
															scrollable
															>
															<v-spacer></v-spacer>
															<v-btn :color="color" text @click="startMenu7 = false" >
																Cancel
															</v-btn>
															<v-btn :color="color" text @click="save7">
																OK
															</v-btn>
														</v-date-picker>
													</v-menu>
												</v-col>
											</v-row>

											<v-text-field
												v-model="cash_edit_amount"
												type="number"
												label="Amount"
												:color="color"
												readonly>
											</v-text-field>

											<v-row>
												<v-col cols="12" sm="6">
													<v-text-field
														v-model="cash_edit_accountable_person"
														type="text"
														label="Accountable Person"
														:color="color">
													</v-text-field>
													
													<v-text-field
														v-model="cash_edit_received_by"
														type="text"
														label="Recieved By"
														:color="color">
													</v-text-field>
												</v-col>

												<v-col cols="12" sm="6">
													<v-text-field
														v-model="cash_edit_prepared_by"
														type="text"
														label="Prepared By"
														:color="color">
													</v-text-field>

													<v-text-field
														v-model="cash_edit_created_by"
														type="text"
														label="Created By"
														readonly
														:color="color">
													</v-text-field>
												</v-col>
											</v-row>

											<v-btn :color="color" dark v-if="cash_edit_payment_text_field" @click="updatePaymentCash"> Update </v-btn>
											<v-btn :color="color" dark v-if="cash_edit_payment_text_field" class="ml-2" @click="cancelEditPaymentCash"> Cancel </v-btn>
										</div>
									</div>

									<div v-else>
										<div
											v-if="cheque_edit_payment_p">
											<p>
												<b>Voucher Number:</b> {{ payment.voucher_number }}
											</p>
											<p>
												<b>Voucher Date:</b> {{ payment.voucher_date | moment('MM-DD-YYYY') }}
											</p>
											<p>
												<b>Amount:</b> {{ payment.amount }}
											</p>
											<p>
												<b>Cheque Number:</b> {{ payment.cheque_number }}
											</p>
											<p>
												<b>Cheque Date:</b> {{ payment.cheque_date | moment('MM-DD-YYYY') }}
											</p>
											<p>
												<b>Bank:</b> {{ payment.bank }}
											</p>
											<p>
												<b>Accountable Person:</b> {{ payment.accountable_person }}
											</p>
											<p>
												<b>Prepared By:</b> {{ payment.prepared_by }}
											</p>
											<p>
												<b>Received By:</b> {{ payment.received_by }}
											</p>
											<p>
												<b>Created By:</b> {{ payment.created_by }}
											</p>
											<v-btn :color="color" dark v-if="cheque_edit_payment_p" @click="editPaymentCheque(payment)"> Edit </v-btn>
											<v-btn :color="color" dark v-if="cheque_edit_payment_p" @click="deletePayment(payment)" class="ml-2"> Delete </v-btn>
										</div>


										<div
											v-if="cheque_edit_payment_text_field">
											<v-input
												v-model="cheque_edit_bill_payment_id"
												hideDetails>
											</v-input>

											<v-row>
												<v-col cols="12" sm="6">
													<v-text-field
														v-model="cheque_edit_voucher_number"
														type="text"
														label="Voucher Number"
														:color="color"
														maxlength="20">
													</v-text-field>

													<v-menu
														ref="startMenu8"
														v-model="startMenu8"
														:close-on-content-click="false"
														:return-value.sync="new_cheque_date"
														transition="scale-transition"
														min-width="290px"
														offset-y>

														<template v-slot:activator="{ on }">
															<v-text-field
																v-model="cheque_edit_cheque_date"
																label="Cheque Date"
																readonly
																v-on="on"
																:color="color"
															></v-text-field>
														</template>
														
														<v-date-picker
															v-model="cheque_edit_cheque_date"
															no-title
															scrollable
															>
															<v-spacer></v-spacer>
															<v-btn :color="color" text @click="startMenu8 = false">
																Cancel
															</v-btn>
															<v-btn :color="color" text @click="save8">
																OK
															</v-btn>
														</v-date-picker>
													</v-menu>

													<v-text-field
														v-model="cheque_edit_cheque_number"
														type="text"
														label="Cheque Number"
														:color="color"
														maxlength="20">
													</v-text-field>	

													<v-text-field
														v-model="cheque_edit_accountable_person"
														type="text"
														label="Accountable Person"
														:color="color">
													</v-text-field>

													<v-text-field
														v-model="cheque_edit_prepared_by"
														type="text"
														label="Prepared By"
														:color="color">
													</v-text-field>
												</v-col>

												<v-col cols="12" sm="6">
													<v-menu
														ref="startMenu7"
														v-model="startMenu7"
														:close-on-content-click="false"
														:return-value.sync="new_voucher_date"
														transition="scale-transition"
														min-width="290px"
														offset-y>

														<template v-slot:activator="{ on }">
															<v-text-field
																v-model="cheque_edit_voucher_date"
																label="Voucher Date"
																readonly
																v-on="on"
																:color="color"
															></v-text-field>
														</template>
														
														<v-date-picker
															v-model="cheque_edit_voucher_date"
															no-title
															scrollable
															>
															<v-spacer></v-spacer>
															<v-btn :color="color" text @click="startMenu7 = false" >
																Cancel
															</v-btn>
															<v-btn :color="color" text @click="save7">
																OK
															</v-btn>
														</v-date-picker>
													</v-menu>

													<v-text-field
														v-model="cheque_edit_amount"
														type="number"
														label="Amount"
														:color="color"
														readonly>
													</v-text-field>

													<v-text-field
														v-model="cheque_edit_bank"
														type="text"
														label="Bank"
														:color="color">
													</v-text-field>

													<v-text-field
														v-model="cheque_edit_received_by"
														type="text"
														label="Recieved By"
														:color="color">
													</v-text-field>

													<v-text-field
														v-model="cheque_edit_created_by"
														type="text"
														label="Created By"
														readonly
														:color="color">
													</v-text-field>
												</v-col>
											</v-row>

											<v-btn :color="color" dark v-if="cheque_edit_payment_text_field" @click="updatePaymentCheque"> Update </v-btn>
											<v-btn :color="color" dark v-if="cheque_edit_payment_text_field" class="ml-2" @click="cancelEditPaymentCheque"> Cancel </v-btn>
										</div>
									</div>
								</v-container>
							</v-card-text>
						</div>
					</v-expansion-panel-content>
			</v-expansion-panel>

			<v-expansion-panel>
				<v-expansion-panel-header> Attachments </v-expansion-panel-header>
				<v-expansion-panel-content>
					<v-btn :color="color" dark @click="add_attachment_dialog = !add_attachment_dialog"> Add Attachment </v-btn>

					<v-dialog
						v-model="add_attachment_dialog" max-width="700px" persistent>
						<v-card>
							<v-card-title> Add Attachment </v-card-title>
							
							<v-card-text>
								<v-container>
									<v-row>
										<v-col cols="12">
											<v-file-input
												v-model="file"	
												ref="file"
												type="file"								
												chips 
												label="File input"
												multiple
												@change="onFileSelected"
												:color="color">
											
												<template v-slot:selection="{ text }">
													<v-chip
														:color="color"
														dark
														label
														small>
														{{ text }}
													</v-chip>
												</template>
											
											</v-file-input>

											<v-text-field
												v-model="attachment_created_by"
												type="text"
												label="Created By"
												readonly
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
									<v-btn color="primary" @click="addAttachment"> Add </v-btn>
									<v-btn color="error" class="ml-2 mr-5" @click="add_attachment_dialog = !add_attachment_dialog"> Close </v-btn>
								</v-row>
							</v-card-subtitle>
					
						</v-card>
					</v-dialog>

					<v-container>
						<v-data-table
							:headers="attachment_header"
							:items="attachments"
							:items-per-page="10"
							class="mt-5 elevation-1">
							
							<template v-slot:item.attachment="{ item }">
								{{ item.attachment }}	
							</template>

							<template v-slot:item.date_created="{ item }">
								{{ item.date_created | moment("MM-DD-YYYY") }}
							</template>

							<template v-slot:item.action="{ item }">
								<v-tooltip left>
									<template v-slot:activator="{ on }">
										<span v-on="on">
											<v-chip
												@click="view_attachment(item)"
												id="qchip3">
												<v-icon
													color="teal"
													small>
													visibility
												</v-icon>
											</v-chip>
										</span>
									</template>
									<span> View Attachment </span>
								</v-tooltip>

								<v-tooltip left>
									<template v-slot:activator="{ on }">
										<span v-on="on">
											<v-chip
												@click="deleteAttachment(item)"
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
									<span> Delete Attachment </span>
								</v-tooltip>

								<v-tooltip bottom>
									<template v-slot:activator="{ on }">
										<span v-on="on">
											<v-chip class="ml-1" id="qchip3" :href="'/img/' + item.attachment" :download="'/img/' + item.attachment">
												<v-icon
													color="primary"
													small>
													get_app
												</v-icon>
											</v-chip>
										</span>
									</template>
									<span> Download Attachment </span>
								</v-tooltip>	
							</template>

						</v-data-table>

						<v-dialog
							v-model="view_image" max-width="900px" persistent>
							<v-card>
								<v-card-title> View Image </v-card-title>
								
								<v-card-text>
									<v-img :src="view_image_full"></v-img>
								</v-card-text>

								<v-card-subtitle>
									<v-row
										align="center"
										justify="end">
										<v-btn color="error" class="ml-2 mr-5" @click="view_image = !view_image"> Close </v-btn>
									</v-row>
								</v-card-subtitle>
							</v-card>
						</v-dialog>

					</v-container>
				</v-expansion-panel-content>
			</v-expansion-panel>
		</v-expansion-panels>
	</v-container>
</template>

<script>
	import { API , token , tokenName } from '../main'
	import moment from 'moment'

	export default {
		data () {
			return {
				panel: [0 , 1 , 2] ,
				tab: null ,
				switch1: true ,
				dark: false ,

				disabled: false ,
				readonly: false ,

				/* Dialog */
				add_payment_dialog: false ,
				add_attachment_dialog: false ,
				edit_billing_p: true ,
				edit_billing_text_field: false ,

				cash_edit_payment_p: true ,
				cash_edit_payment_text_field: false ,

				cheque_edit_payment_p: true ,
				cheque_edit_payment_text_field: false ,

				view_image: false ,
				soa_number: this.$route.params.id ,

				/* Get Data */
				bills: [] ,
				billings: [] ,
				payments: [] , 
				attachments: [] ,

				startMenu13: false ,
				startMenu4: false ,
				startMenu1: false ,
				startMenu11: false ,
				startMenu2: false ,
				startMenu5: false ,
				startMenu6: false ,
				startMenu7: false ,
				startMenu8: false ,

				start: moment().format("YYYY-MM-DD") ,

				/* Edit Billing */
				edit_billing_id: "" ,
				edit_bill_id: "",
				edit_soa_number: 0 ,
				edit_account_name: "" ,
				edit_account_number: 0,
				edit_billing_period_start: moment().format("YYYY-MM-DD") ,
				edit_billing_period_end: moment().format("YYYY-MM-DD") ,
				edit_due_date: moment().format("YYYY-MM-DD") ,
				edit_billing_amount: 0 ,
				edit_date_received: moment().format("YYYY-MM-DD") ,
				edit_billing_created_by: tokenName ,
				edit_payment_status: "" ,

				new_billing_period_start: "" ,
				new_billing_period_end: "" ,
				new_due_date: "" ,
				new_date_recieved: "" ,

				/* Edit Billing */

				/* Payment */				
				payment_billing_id: "",
				// cash
				cash_voucher_number: 0 ,
				cash_voucher_date: moment().format("YYYY-MM-DD") ,
				cash_amount: 0 ,
				cash_accountable_person: "" ,
				cash_received_by: "" ,
				cash_prepared_by: "" ,
				cash_created_by: tokenName ,
				//cheque
				cheque_voucher_number: 0 ,
				cheque_voucher_date: moment().format("YYYY-MM-DD") ,
				cheque_amount: 0 ,
				cheque_number: 0 ,
				cheque_date: moment().format("YYYY-MM-DD") ,
				cheque_bank: "" ,
				cheque_accountable_person: "" ,
				cheque_received_by: "" ,
				cheque_prepared_by: "" ,
				cheque_created_by: tokenName ,

				/* Edit Payment */
				// cash
				cash_edit_bill_payment_id: null ,
				cash_edit_payment_billing_id: "",
				cash_edit_voucher_number: 0 ,
				cash_edit_voucher_date: "" ,
				cash_edit_amount: 0 ,
				cash_edit_accountable_person: "" ,
				cash_edit_received_by: "" ,
				cash_edit_prepared_by: "" ,
				cash_edit_created_by: tokenName ,
				// cheque
				cheque_edit_bill_payment_id: null ,
				cheque_edit_payment_billing_id: "",
				cheque_edit_voucher_number: 0 ,
				cheque_edit_voucher_date: "" ,
				cheque_edit_amount: 0 ,
				cheque_edit_cheque_number: 0 ,
				cheque_edit_cheque_date: "" ,
				cheque_edit_bank: "" ,
				cheque_edit_accountable_person: "" ,
				cheque_edit_received_by: "" ,
				cheque_edit_prepared_by: "" ,
				cheque_edit_created_by: tokenName ,

				new_voucher_date: "" ,
				new_cheque_date: "" ,
				/* Edit Payment */
				type: null ,

				/* Attachment */
				file: null ,
				attachment_created_by: tokenName ,
				view_image_full: "" ,
				attachment_header: [
					{
						text: "Attachments" ,
						value: "attachment" ,
						align: "center" ,
						sortable: false ,
					} ,
					{
						text: "Created By" ,
						value: "created_by" ,
					} ,
					{
						text: "Date Added" ,
						value: "date_created" ,
					} ,
					{
						text: "Action" ,
						value: "action" ,
						align: "center" ,
						sortable: false ,
					}
				],

				numberPattern: /^[0-9 -]*$/,
				soaPattern: /^[A-Za-z0-9 -]*$/,
				namePattern: /^[A-Za-z .-]*$/,
				color: null ,
			}
		} ,

		methods: {
			/* function datepicker edit */

			save13 () {
				this.$refs.startMenu13 = this.new_billing_period_start;
				this.startMenu13 = false;
			} ,

			save4 () {
				this.$refs.startMenu4 = this.new_billing_period_end;
				this.startMenu4 = false;
			} ,

			save5 () {
				this.$refs.startMenu5 = this.new_due_date;
				this.startMenu5 = false;
			} ,

			save6 () {
				this.$refs.startMenu6 = this.new_date_recieved;
				this.startMenu6 = false;
			} ,

			save7 () {
				this.$refs.startMenu7 = this.new_voucher_date;
				this.startMenu7 = false;
			} ,

			save8 () {
				this.$refs.startMenu8 = this.new_cheque_date;
				this.startMenu8 = false;
			} ,

			/* Function datepicker edit */

			editBilling (billing) {

				if (this.payments.length === 0) {

					this.edit_billing_p            = false;
					this.edit_billing_text_field   = true;
					this.edit_billing_id 		   = billing.billing_id;
					this.edit_bill_id 			   = billing.bill_id;
					this.edit_soa_number           = billing.soa_number;
					this.edit_account_name         = billing.account_name;
					this.edit_account_number	   = billing.account_number;
					this.edit_billing_period_start = moment(billing.billing_period_start).format("YYYY-MM-DD");
					this.edit_billing_period_end   = moment(billing.billing_period_end).format("YYYY-MM-DD");
					this.edit_due_date             = moment(billing.due_date).format("YYYY-MM-DD");
					this.edit_billing_amount	   = billing.amount;
					this.edit_date_received		   = moment(billing.date_recieved).format("YYYY-MM-DD");
					this.edit_payment_status       = billing.payment_status;
					this.edit_remarks              = billing.remarks;

				} else {

					this.$swal(
						'WARNING!' , 
						'This billing already have a payment , Editing this may cause a problem!' , 
						'warning' ,
					);

				}


			} ,

			cancelEditBilling () {

				this.edit_billing_p            = true;
				this.edit_billing_text_field   = false;
				this.edit_billing_id           = "";
				this.edit_bill_id              = "";
				this.edit_soa_number           = 0;
				this.edit_account_name         = "";
				this.edit_billing_period_start = moment().format("YYYY-MM-DD");
				this.edit_billing_period_end   = moment().format("YYYY-MM-DD");
				this.edit_due_date             = moment().format("YYYY-MM-DD");
				this.edit_billing_amount	   = 0;
				this.edit_date_received		   = moment().format("YYYY-MM-DD");
				this.edit_billing_created_by   = "";
				this.edit_payment_status       = 0;

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

			editAccountChange (account_name) {
				fetch(API + "/get/bills/account_number/" + account_name)
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.edit_account_number = json.account_number;
                });
			} ,

			updateBilling () {
				let billing = {
					billID      : this.edit_bill_id ,
					billingID   : this.edit_billing_id ,
					soaNumber   : this.edit_soa_number ,
					billStart   : this.edit_billing_period_start ,
					billEnd     : this.edit_billing_period_end ,
					amount      : this.edit_billing_amount ,
					dueDate     : this.edit_due_date ,
					dateReceived: this.edit_date_received ,
					createdBy   : this.edit_billing_created_by ,
					remarks     : this.edit_remarks ,
				};

				if (!billing.soaNumber.trim() || !billing.billStart || !billing.billEnd || !billing.amount || !billing.dueDate || !billing.dateReceived) {
					this.$swal('ERROR!' , 'All fields are required' , 'error');
				
				} else {
					if(billing.soaNumber.match(this.soaPattern) == null){
						this.$swal("ERROR", "Invalid character on SOA Number", "error");
					}else if(billing.createdBy.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Created By", "error");
					}else{
						billing.amount = parseFloat(billing.amount).toFixed(2);
						fetch(API + '/edit/billings/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify(billing)
						}).then(response => response.json())
						.then(data => {
							if(data.success === true){
								this.$swal("SUCCESS", "Billing updated successfully", "success");
								this.edit_billing_p            = true;
								this.edit_billing_text_field   = false;
								this.edit_billing_id           = "";
								this.edit_soa_number           = 0;
								this.edit_account_name         = "";
								this.edit_billing_period_start = moment().format("YYYY-MM-DD");
								this.edit_billing_period_end   = moment().format("YYYY-MM-DD");
								this.edit_due_date             = moment().format("YYYY-MM-DD");
								this.edit_billing_amount	   = 0;
								this.edit_date_received		   = moment().format("YYYY-MM-DD");
								this.edit_remarks              = "";
								this.getBills();
								this.getViewBilling();
							}else if (data.success === false){
								this.$swal("WARING", "SOA Number is Already Use , Please Try Again.", "error");
							} else {
								this.$swal("ERROR", "Update failed", "error");
							}
						});

					}
				}
			} ,

			addPaymentCash () {
				let addPaymentCash = {
					billing_id        : this.soa_number ,
					voucher_number	  : this.cash_voucher_number ,
					voucher_date  	  : this.cash_voucher_date ,
					amount 		  	  : this.cash_amount ,
					accountable_person: this.cash_accountable_person ,
					received_by	      : this.cash_received_by ,
					prepared_by       : this.cash_prepared_by ,
					created_by        : this.cash_created_by ,
				};
				if (!addPaymentCash.voucher_number.toString().trim() || !addPaymentCash.voucher_date || !addPaymentCash.amount || !addPaymentCash.accountable_person.trim() || !addPaymentCash.received_by.trim() || !addPaymentCash.prepared_by.trim() ) {

					this.$swal(
						'ERROR!' , 
						'All fields are required' , 
						'error'
					);

				} else {
					if(addPaymentCash.voucher_number.toString().match(this.numberPattern) == null){
						this.$swal("ERROR", "Invalid character on Voucher Number", "error");
					}else if(addPaymentCash.accountable_person.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Accountable Person", "error");
					}else if(addPaymentCash.received_by.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Recieved by", "error");
					}else if(addPaymentCash.prepared_by.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Prepared by", "error");
					}else{

						//addPaymentCash.amount = parseFloat(addPaymentCash).toFixed(2);
						fetch(API + '/get/billings/amount/' + addPaymentCash.billing_id)
						.then(response => response.json())
						.then(data => {
							if(addPaymentCash.amount < data[0].amount){
								this.$swal("ERROR", "Add payment failed, the payment amount is less than the billing amount", 'error');							
							}else{

								fetch(API + "/check/trash/payments/" + addPaymentCash.billing_id  + "/" + addPaymentCash.voucher_number)
								.then(data => {
									return data.json();
								})
								.then(json => {
									if (json.success === true) {

										this.$swal(
											'SORRY!' , 
											'This voucher number already use located in trash' , 
											'error'
										);

									} else {

										fetch(API + '/add/new/payment/cash/', { 
											method: 'post',
											headers: {
													'Content-Type': 'application/json'},
											body: JSON.stringify(addPaymentCash)
										}).then(data => {
											return data.json(); 
										}).then(json => {
											if(json.success === true) {
												
												this.$swal(
													'Success' , 
													'New Payment Added Successfully!' , 
													'success'
												);

												this.cash_voucher_number     = "";
												this.cash_voucher_date       = moment().format("YYYY-MM-DD");
												this.cash_amount             = 0;
												this.cash_accountable_person = "";
												this.cash_received_by        = "";
												this.cash_prepared_by        = "";
												this.add_payment_dialog = false;

												this.getViewBilling();

											} else {
												this.$swal(
													'ERROR!' , 
													'Something Went Wrong , Please Check the Details!' , 
													'error'
												);
											}
										});
									}
								});


							}
						});
					}
				}
			} ,

			addPaymentQheque () {
				let addPaymentQheque = {
					billing_id        : this.soa_number ,
					voucher_number	  : this.cheque_voucher_number ,
					voucher_date  	  : this.cheque_voucher_date ,
					amount 		  	  : this.cheque_amount ,
					cheque_number 	  : this.cheque_number ,
					cheque_date 	  : this.cheque_date ,
					bank		      : this.cheque_bank ,
					accountable_person: this.cheque_accountable_person ,
					received_by	      : this.cheque_received_by ,
					prepared_by       : this.cheque_prepared_by ,
					created_by        : this.cheque_created_by ,
				};

				if (!addPaymentQheque.voucher_number.toString().trim() || !addPaymentQheque.voucher_date || !addPaymentQheque.amount || !addPaymentQheque.cheque_number.toString().trim() || !addPaymentQheque.cheque_date || !addPaymentQheque.bank.trim() || !addPaymentQheque.accountable_person.trim() || !addPaymentQheque.received_by.trim() || !addPaymentQheque.prepared_by.trim()) {

					this.$swal(
						'ERROR!' , 
						'All fields are required' , 
						'error'
					);

				} else {
					if(addPaymentQheque.voucher_number.toString().match(this.numberPattern) == null){
						this.$swal("ERROR", "Invalid character on Voucher Number");
					}else if(addPaymentQheque.cheque_number.toString().match(this.numberPattern) == null){
						this.$swal("ERROR", "Invalid character on Cheque Number", "error");
					}else if(addPaymentQheque.bank.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Bank", "error");
					}else if(addPaymentQheque.accountable_person.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Accountable Person", "error");
					}else if(addPaymentQheque.received_by.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Recieved by", "error");
					}else if(addPaymentQheque.prepared_by.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Prepared by", "error");
					}else{
						fetch(API + '/get/billings/amount/' + addPaymentQheque.billing_id)
						.then(response => response.json())
						.then(data => {
							if(addPaymentQheque.amount < data[0].amount){
								this.$swal("ERROR", "Add payment failed, the payment amount is less than the billing amount", 'error');							
							}else{

								fetch(API + "/check/trash/payments/" + addPaymentQheque.billing_id  + "/" + addPaymentQheque.voucher_number)
								.then(data => {
									return data.json();
								})
								.then(json => {
									if (json.success === true) {

										this.$swal(
											'SORRY!' , 
											'This voucher number already use located in trash' , 
											'error'
										);

									} else {

										fetch(API + '/add/new/payment/cheque/', { 
											method: 'post',
											headers: {
													'Content-Type': 'application/json'},
											body: JSON.stringify(addPaymentQheque)
										}).then(data => {
											return data.json(); 
										}).then(json => {
											if(json.success === true) {
												
												this.$swal(
													'Success' , 
													'New Payment Added Successfully!' , 
													'success'
												);

												this.cheque_voucher_number     = "";
												this.cheque_voucher_date       = moment().format("YYYY-MM-DD");
												this.cheque_amount             = 0;
												this.cheque_number             = 0; 
												this.cheque_date               = moment().format("YYYY-MM-DD");
												this.cheque_bank               = "";
												this.cheque_accountable_person = "";
												this.cheque_received_by        = "";
												this.cheque_prepared_by        = "";	
												this.add_payment_dialog = false;

												this.getViewBilling();

											} else {
												this.$swal(
													'ERROR!' , 
													'Something Went Wrong , Please Check the Details!' , 
													'error'
												);
											}
										});
									}
								});
							}
						});
					}
				}
			} ,

			editPaymentCash (payment) {
				this.cash_edit_payment_text_field = true;
				this.cash_edit_payment_p          = false;
				this.cash_edit_bill_payment_id    = payment.bill_payment_id;
				this.cash_edit_payment_billing_id = payment.billing_id;
				this.cash_edit_voucher_number     = payment.voucher_number;
				this.cash_edit_voucher_date       = moment(payment.voucher_date).format("YYYY-MM-DD");
				this.cash_edit_amount             = payment.amount;
				this.cash_edit_accountable_person = payment.accountable_person;
				this.cash_edit_received_by        = payment.received_by;
				this.cash_edit_prepared_by        = payment.prepared_by;
				this.cast_edit_created_by         = tokenName;
			} ,

			editPaymentCheque (payment) {
				this.cheque_edit_payment_text_field = true;
				this.cheque_edit_payment_p          = false;
				this.cheque_edit_bill_payment_id    = payment.bill_payment_id;
				this.cheque_edit_payment_billing_id = payment.billing_id;
				this.cheque_edit_voucher_number     = payment.voucher_number;
				this.cheque_edit_voucher_date       = moment(payment.voucher_date).format("YYYY-MM-DD");
				this.cheque_edit_amount             = payment.amount;
				this.cheque_edit_cheque_number      = payment.cheque_number;
				this.cheque_edit_cheque_date        = moment(payment.cheque_date).format("YYYY-MM-DD");
				this.cheque_edit_bank               = payment.bank;
				this.cheque_edit_accountable_person = payment.accountable_person;
				this.cheque_edit_received_by        = payment.received_by;
				this.cheque_edit_prepared_by        = payment.prepared_by;
				this.cheque_edit_created_by         = tokenName;
			} ,

			cancelEditPaymentCash () {
				this.cash_edit_payment_text_field = false;
				this.cash_edit_payment_p          = true;
				this.cash_edit_bill_payment_id    = null;
				this.cash_edit_payment_billing_id = "";
				this.cash_edit_voucher_number     = 0;
				this.cash_edit_voucher_date       = moment().format("YYYY-MM-DD");
				this.cash_edit_amount             = 0;
				this.cash_edit_accountable_person = "";
				this.cash_edit_received_by        = "";
				this.cash_edit_prepared_by        = "";
			} ,

			cancelEditPaymentCheque () {
				this.cheque_edit_payment_text_field = false;
				this.cheque_edit_payment_p          = true;
				this.cheque_edit_bill_payment_id    = null;
				this.cheque_edit_payment_billing_id = "";
				this.cheque_edit_voucher_number     = 0;
				this.cheque_edit_voucher_date       = moment().format("YYYY-MM-DD");
				this.cheque_edit_amount             = 0;
				this.cheque_number                  = 0;
				this.cheque_date                    = moment().format("YYYY-MM-DD");
				this.cheque_bank 					= "";
				this.cheque_edit_accountable_person = "";
				this.cheque_edit_received_by        = "";
				this.cheque_edit_prepared_by        = "";
			} ,

			updatePaymentCash () {

				let updatePayment = {
					edit_bill_payment_id   : this.cash_edit_bill_payment_id ,
					edit_billing_id        : this.cash_edit_payment_billing_id,
					edit_voucher_number    : this.cash_edit_voucher_number,
					edit_voucher_date      : this.cash_edit_voucher_date ,
					edit_amount            : this.cash_edit_amount ,
					edit_accountable_person: this.cash_edit_accountable_person ,
					edit_received_by       : this.cash_edit_received_by ,
					edit_prepared_by       : this.cash_edit_prepared_by ,
					edit_created_by        : this.cash_edit_created_by,

				} ;

				if (!updatePayment.edit_voucher_number.toString().trim() || !updatePayment.edit_voucher_date || !updatePayment.edit_amount || !updatePayment.edit_accountable_person.trim() || !updatePayment.edit_received_by.trim() || !updatePayment.edit_prepared_by.trim()) {

					this.$swal(
						'Warning!' , 
						'All fields are required' , 
						'warning'
					);

				} else { 
					if(updatePayment.edit_voucher_number.toString().match(this.numberPattern) == null){
						this.$swal("ERROR", "Invalid character on Voucher Number", "error");
					}else if(updatePayment.edit_accountable_person.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Accountable Person", "error");
					}else if(updatePayment.edit_received_by.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Recieved by", "error");
					}else if(updatePayment.edit_prepared_by.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Prepared by", "error");
					}else{
						fetch(API + '/get/billings/amount/' + updatePayment.edit_billing_id)
						.then(response => response.json())
						.then(data => {
							if(updatePayment.edit_amount < data[0].amount){
								this.$swal("ERROR", "Update payment failed, the payment amount is less than the billing amount", 'error');							
							}else{

								fetch(API + "/check/trash/payments/" + updatePayment.edit_billing_id  + "/" + updatePayment.edit_voucher_number)
								.then(data => {
									return data.json();
								})
								.then(json => {
									if (json.success === true) {

										this.$swal(
											'SORRY!' , 
											'This voucher number already use located in trash' , 
											'error'
										);

									} else { 

										fetch(API + '/update/payment/cash/', { 
											method: 'post',
											headers: {
													'Content-Type': 'application/json'},
											body: JSON.stringify(updatePayment)
										}).then(data => {
											return data.json(); 
										}).then(json => {
											if(json.success === true) {
												this.$swal(
													'Success' , 
													'Payment Updated Successfully!' , 
													'success'
												);

												this.cash_edit_voucher_number     = 0;
												this.cash_edit_voucher_date       = moment().format("YYYY-MM-DD");
												this.cash_edit_amount             = 0;
												this.cash_edit_accountable_person = "";
												this.cash_edit_received_by        = "";
												this.cash_edit_prepared_by        = "";
												this.cash_edit_payment_text_field = false;
												this.cash_edit_payment_p          = true;

												this.getViewBilling();

											} else {
												this.$swal(
													'ERROR!' , 
													'Something Went Wrong , Please Check the Details!' , 
													'error'
												);
											}
										});
									}
								});	
							}
						});
					}
				}
			} ,

			updatePaymentCheque () {

				let updatePayment = {
					edit_bill_payment_id   : this.cheque_edit_bill_payment_id ,
					edit_billing_id        : this.cheque_edit_payment_billing_id,
					edit_voucher_number    : this.cheque_edit_voucher_number ,
					edit_voucher_date      : this.cheque_edit_voucher_date ,
					edit_amount            : this.cheque_edit_amount ,
					edit_cheque_number     : this.cheque_edit_cheque_number ,
					edit_cheque_date       : this.cheque_edit_cheque_date ,
					edit_bank              : this.cheque_edit_bank ,
					edit_accountable_person: this.cheque_edit_accountable_person ,
					edit_received_by       : this.cheque_edit_received_by ,
					edit_prepared_by       : this.cheque_edit_prepared_by ,
					edit_created_by        : this.cheque_edit_created_by ,

				} ;

				if (!updatePayment.edit_voucher_number.toString().trim() || !updatePayment.edit_voucher_date || !updatePayment.edit_amount || !updatePayment.edit_cheque_number.toString().trim() || !updatePayment.edit_cheque_date || !updatePayment.edit_bank.trim() || !updatePayment.edit_accountable_person.trim() || !updatePayment.edit_received_by.trim() || !updatePayment.edit_prepared_by.trim() || !updatePayment.edit_created_by) {

					this.$swal(
						'Warning!' , 
						'All fields are required' , 
						'warning'
					);

				} else { 
					if(updatePayment.edit_voucher_number.toString().match(this.numberPattern) == null){
						this.$swal("ERROR", "Invalid character on Voucher Number", "error");
					}else if(updatePayment.edit_cheque_number.toString().match(this.numberPattern) == null){
						this.$swal("ERROR", "Invalid character on Cheque Number", "error");
					}else if(updatePayment.edit_bank.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Bank", "error");
					}else if(updatePayment.edit_accountable_person.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Accountable Person", "error");
					}else if(updatePayment.edit_received_by.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on Recieved by", "error");
					}else if(updatePayment.edit_prepared_by.match(this.namePattern) == null){
						this.$swal("ERROR", "Invalid character on prepared_by", "error");
					}else{
						fetch(API + '/get/billings/amount/' + updatePayment.edit_billing_id)
						.then(response => response.json())
						.then(data => {
							if(updatePayment.edit_amount < data[0].amount){
								this.$swal("ERROR", "Update payment failed, the payment amount is less than the billing amount", 'error');							
							}else{

								fetch(API + "/check/trash/payments/" + updatePayment.edit_billing_id  + "/" + updatePayment.edit_voucher_number)
								.then(data => {
									return data.json();
								})
								.then(json => {
									if (json.success === true) {

										this.$swal(
											'SORRY!' , 
											'This voucher number already use located in trash' , 
											'error'
										);

									} else {
										
										fetch(API + '/update/payment/cheque/', { 
											method: 'post',
											headers: {
													'Content-Type': 'application/json'},
											body: JSON.stringify(updatePayment)
										}).then(data => {
											return data.json(); 
										}).then(json => {
											if(json.success === true) {
												this.$swal(
													'Success' , 
													'Payment Updated Successfully!' , 
													'success'
												);

												this.cheque_edit_voucher_number     = 0;
												this.cheque_edit_voucher_date       = moment().format("YYYY-MM-DD");
												this.cheque_edit_amount             = 0;
												this.cheque_edit_cheque_number      = 0;
												this.cheque_edit_cheque_date        = moment().format("YYYY-MM-DD");
												this.cheque_edit_bank               = "";
												this.cheque_edit_accountable_person = "";
												this.cheque_edit_received_by        = "";
												this.cheque_edit_prepared_by        = "";
												this.cheque_edit_payment_text_field = false;
												this.cheque_edit_payment_p          = true;

												this.getViewBilling();
											} else {
												this.$swal(
													'ERROR!' , 
													'Something Went Wrong , Please Check the Details!' , 
													'error'
												);
											}
										});
									}
								});		
							}
						});
					}
				}
			} ,

			deletePayment (payment) {

				let deletePayment = {
					bill_payment_id: payment.bill_payment_id ,
					billing_id     : payment.billing_id
				};

				this.$swal({

					overflowy         : 'hidden' ,
                    title             : 'Are you sure?' ,
                    text              : "You want to delete this Item?" ,
                    icon              : "warning" ,
                    showCancelButton  : true ,
                    cancelButtonText  : 'CANCEL' ,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor : '#d33',
                    confirmButtonText : 'YES, DELETE IT!'

                }).then((result) => { 

                    if (result.value) {

						fetch(API + '/delete/payment/', { 
							method: 'post',
							headers: {
									'Content-Type': 'application/json'},
							body: JSON.stringify(deletePayment)
						}).then(data => { 

							return data.json(); 

						}).then(json => { 

							if (json.success === true) {

								this.$swal(
									'Success' , 
									'Payment Successfully Deleted!' , 
									'success'
								);

								this.getViewBilling();

							} else {

								this.$swal(
									'ERROR!' , 
									'Something Went Wrong , Please Try Again!' , 
									'error'
								);
							}

						});

						fetch(API + '/update/payment/status',{
							method: 'post',
							headers: {
								'Content-Type' : 'application/json'
							},
							body: JSON.stringify(deletePayment)
						}).then(response =>response.json());
                    }
                    
                });    	


			} ,

			onFileSelected () {
				this.file = this.$refs.file.files[0];
			} ,

			addAttachment () {		
				let addAttachment = {
					file      : this.file ,
					created_by: this.attachment_created_by ,
				};
				let file_name = this.file[0].name;

				if (!addAttachment.file) {
					this.$swal(
						'Warning' , 
						'All fields are required!' , 
						'warning'
					);
				}else if(!file_name.endsWith(".jpg") && !file_name.endsWith(".png") && !file_name.endsWith(".jpeg")){
					this.$swal("SORRY", "Invalid file, system only accept jpg/jpeg or png images", "error");
				}
				else {					
					const file  = this.file[0];
					const formData = new FormData();

					formData.append('myFile' , file);
					formData.append('billing_id' , this.soa_number);
					formData.append('created_by' , addAttachment.created_by);

					fetch(API + "/add/attachment/storage/" , {

						method: 'post',
						header: { 'Content-Type': 'application/json' } ,
						body: formData ,

					}).then(data => {

						return data.json(); 

					}).then(json => { 

						if (json.success === true) {

							this.$swal(
								'Success' , 
								'Attachment Added Successfully!' , 
								'success'
							);

							this.getViewBilling();
							this.add_attachment_dialog = false;
							this.file = null;

						} else {

							this.$swal(
								'ERROR!' , 
								'Something Went Wrong , Please Try Again!' , 
								'error'
							);

						}

					});
				}
			} ,

			deleteAttachment(item) {
				let id = item.ID;

				this.$swal({

					overflowy         : 'hidden' ,
                    title             : 'Are you sure?' ,
                    text              : "You want to delete this Item?" ,
                    icon              : "warning" ,
                    showCancelButton  : true ,
                    cancelButtonText  : 'CANCEL' ,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor : '#d33',
                    confirmButtonText : 'YES, DELETE IT!'

                }).then((result) => { 

                    if (result.value) {

						fetch(API + "/delete/attachment/" + id)
						.then(data => {

							return data.json();

						}).then(json => {

							if (json.success === true) {

								this.$swal(
									'SUCCESS' , 
									'Attachment Deleted Successfully!' , 
									'success'
								);

								this.getViewBilling();

							} else {

								this.$swal(
									'ERROR' , 
									'Something Went Wrong!' , 
									'error'
								);

							}

						});

                    }
                });
			} ,

			view_attachment(item) {

				this.view_image = true;
				this.view_image_full = '/img/' + item.attachment;
			} ,
			
			getViewBilling () {
				fetch(API + "/get/view/billing/" + this.soa_number)
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.billings      = json;
                    this.cash_amount   = json[0].amount; 
                    this.cheque_amount = json[0].amount;
                });
                
                fetch(API + "/get/view/payment/" + this.soa_number)
				.then(data => {
                    return data.json();
                })
                .then(json => {
                    this.payments = json;
                });

                fetch(API + "/get/view/attachment/" + this.soa_number)
                .then(data => {
                    return data.json();
                })
                .then(json => {
                    this.attachments = json;
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
			this.getViewBilling();
			this.getBills();	
		}
	}
</script>