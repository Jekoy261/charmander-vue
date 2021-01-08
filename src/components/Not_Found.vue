<template>
	<v-container fluid>
		<v-card>
			<v-card-text>
				Page Not Found.
			</v-card-text>
		</v-card>
	</v-container>
</template>

<script>
	export default {

		data () {
			return {
				//drawer: true ,
			}
		} , 
		methods: {

		} ,

		beforeMount () {
			this.$emit('verify');
		}
	}	 
</script>