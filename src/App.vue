<template>
	<v-app>
		<div
			v-if="drawerSetting2">
			<v-navigation-drawer 
				app
				v-model="drawer"
				enable-resize-watcher 
				:mini-variant.sync="expand"
				width="250"
				:dark="dark">
				<v-list>
					<v-list-item class="px-5" style="margin-top: -5px; margin-bottom: -4px" to="/myprofile">
						<v-list-item-avatar>
							<v-img src="./assets/images/charmander1.png"></v-img>
						</v-list-item-avatar>

							<v-list-item-title class="title"> {{ name }} </v-list-item-title>
					</v-list-item>
				</v-list>

				<v-divider></v-divider>

				<v-list
					nav
					dense>
					<v-list-item 
						link
						to="/dashboard">
						<v-list-item-icon>
							<v-icon :color="color">dashboard</v-icon>
						</v-list-item-icon>
						<v-list-item-title> Dashboard </v-list-item-title>
					</v-list-item>
					
					<v-list-item
						link
						to="/billings">
						<v-list-item-icon>
							<v-icon :color="color">attach_money</v-icon>
						</v-list-item-icon>
						<v-list-item-title> Billings </v-list-item-title>
					</v-list-item>	

					<v-list-item 
						link
						to="/bills">
						<v-list-item-icon>
							<v-icon :color="color">format_list_numbered</v-icon>
						</v-list-item-icon>
						<v-list-item-title> Bills </v-list-item-title>
					</v-list-item>

					<v-list-item
						link
						to="/service_provider">
						<v-list-item-icon>
							<v-icon :color="color">phone</v-icon>
						</v-list-item-icon>
						<v-list-item-title> Service Providers </v-list-item-title>
					</v-list-item>
					
					<v-list-item 
						link
						to="/reports">
						<v-list-item-icon>
							<v-icon :color="color">picture_as_pdf</v-icon>
						</v-list-item-icon>
						<v-list-item-title> Reports </v-list-item-title>
					</v-list-item>

					<v-list-item 
						link
						to="/trash">
						<v-list-item-icon>
							<v-icon :color="color">restore_from_trash</v-icon>
						</v-list-item-icon>
						<v-list-item-title> Trash </v-list-item-title>
					</v-list-item>
					
					<template
						v-if="admin.length === 0">
					</template>

					<template
						v-else>
						<v-list-item 
							link
							to="/users">
							<v-list-item-icon>
								<v-icon :color="color">supervised_user_circle</v-icon>
							</v-list-item-icon>
							<v-list-item-title> Users </v-list-item-title>
						</v-list-item>
					</template>

					<v-list-item 
						link
						to="/settings">
						<v-list-item-icon>
							<v-icon :color="color">settings_applications</v-icon>
						</v-list-item-icon>
						<v-list-item-title> Settings </v-list-item-title>
					</v-list-item>
				</v-list>

				<template v-slot:append>
					<div class="pa-2" v-if="month">
						<v-list-item align="center">
							<v-list-item-title><h3>{{ new Date() | moment("MMMM YYYY") }}</h3></v-list-item-title>
						</v-list-item>
					</div>
				</template>
			</v-navigation-drawer>
		</div>
	
		<v-app-bar
			v-if="drawerSetting2"
			:dark="dark"
			fixed
			app>
			<v-app-bar-nav-icon @click.stop="drawerClick"></v-app-bar-nav-icon>
			<v-toolbar-title> Project Charmander </v-toolbar-title>
			<v-spacer></v-spacer>
			<v-menu
				left
				bottom>
				<template v-slot:activator="{ on }">
					<v-btn icon v-on="on">
						<v-icon>more_vert</v-icon>
					</v-btn>
				</template>
		
				<v-list>
					<v-list-item>
						<v-list-item-title> 
							<v-btn text block to="/myprofile">
								My Profile 
							</v-btn>	
						</v-list-item-title>
					</v-list-item>
		
					<v-list-item>
						<v-list-item-title>
							<v-container>
								<v-switch v-model="switch1" @change="dark_mode" label="Dark Mode"></v-switch>
							</v-container>
						</v-list-item-title>
					</v-list-item>
		
					<v-list-item>
						<v-list-item-title> 
							<v-btn text block @click="logout">
								Logout 
							</v-btn>	
						</v-list-item-title>
					</v-list-item>
				</v-list>
			</v-menu>
		</v-app-bar>

		<v-content>
			<router-view 
				@verify="verify" 
				@getActiveColor="getActiveColor"
				@getActiveDarkMode="getActiveDarkMode">
			</router-view>
		</v-content>
    </v-app>
</template>

<script>
import { API , token , tokenName } from "./main.js"

export default {
	name: 'App',

	components: {
	},

	data () {
		return {
			admin: [] ,
			drawer: true ,
			status: 0 ,
			token: token ,
			name: tokenName ,
			color: null ,
			dark: true ,
			switch1: true ,
			drawerSetting2: true ,
			expand: false ,
			month: true ,
		} 
	},

	methods: {
		verify () {
            if (!token) {
                window.location.href = "/#/login";
            }
        } ,

		drawerSetting () {
			let name = this.name;

			if (!name) {
				this.drawerSetting2 = false;
			} else {
				this.drawerSetting2 = true;
			}
		} ,

		drawerClick () {
			let drawer = this.expand;

			if (drawer === true) {
				this.expand = false;
				this.month  = true;
			} else {
				this.expand = true;
				this.month  = false;
			}
		} ,

		getDarkColor () {
			fetch(API + '/get/dark/' + token)
			.then(response => response.json())
			.then(data => {
				window.console.log(data.success);
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

		getActiveColor () {
			fetch(API + '/get/active/color/' + token)
			.then(response => response.json())
			.then(data => {
				this.color = data[0].color;
			});
		} ,

		dark_mode () {
			let switch1 = this.switch1;

			if (switch1 === false) {
				fetch(API + '/update/dark/mode/' + token + "/" + switch1)
				.then(response => response.json())
				.then(data => {
					if (data.success === true) {		
						this.getActiveDarkMode();
					} 
				});
			} else {
				fetch(API + '/update/dark/mode/' + token + "/" + switch1)
				.then(response => response.json())
				.then(data => {
					if (data.success === true) {
						this.getActiveDarkMode();								
					} 
				});
			}
		} ,

		logout () {
			window.localStorage.setItem("__TokenName" , "");
			window.localStorage.removeItem("__TokenId");
			window.location.reload();
		} ,
		
		getAdmin() {
			fetch(API + '/get/admin/' + token)
			.then(response => response.json())
			.then(data => {
				this.admin = data;
			});
		} ,
	} , 

	beforeMount () {
		this.getAdmin();
		this.getActiveColor();
		this.getDarkColor();
		this.getActiveDarkMode();
		this.drawerSetting();
	} ,
};
</script>

<style lang="scss">
	#app {
		//background-color: #444;
	}
</style>