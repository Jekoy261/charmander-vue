/* Plugins */
import Vue from 'vue'
import App from './App.vue'
import VueRouter      from 'vue-router'
import VueSweetalert2 from 'vue-sweetalert2'
import vuetify        from './plugins/vuetify'

/* Pages */
import Login        	 from './components/Login'
import Users             from './components/Users'
import MyProfile         from './components/MyProfile'
import Dashboard    	 from './components/Dashboard'
import Reports      	 from './components/Reports'
import Billings     	 from './components/Billings'
import View_Billing 	 from './components/View_Billing'
import Bills        	 from './components/Bills'
import Service_Providers from './components/Service_Provider'
import Trash        	 from './components/Trash'
import Settings     	 from './components/Settings'
import Not_Found    	 from './components/Not_Found'

/* Plugins */
import 'sweetalert2/dist/sweetalert2.min.css';
import moment from 'vue-moment'

/* Node Js */
export const API = 'http://localhost:3000';
export const token = window.localStorage.getItem("__TokenId");
export const tokenName = window.localStorage.getItem("__TokenName");
export const darkMode = window.localStorage.getItem("__darkMode");

Vue.use(VueRouter)
Vue.use(VueSweetalert2)
Vue.use(moment)

Vue.config.productionTip = false

const routes = [
	{ path: '/'         	 	, component: Dashboard , } ,
	{ path: '/login'    	 	, component: Login     , } ,
	{ path: '/users'            , component: Users     , } ,
	{ path: '/myprofile/'       , component: MyProfile , } ,
	{ path: '/dashboard'	 	, component: Dashboard , } ,
	{ path: '/reports'  	 	, component: Reports   , } ,
	{ path: '/billings' 	 	, component: Billings  , } ,
	{ path: '/view/:id'  	 	, component: View_Billing , } ,
	{ path: '/bills'     	 	, component: Bills     , } ,
	{ path: '/service_provider' , component: Service_Providers , } ,
	{ path: '/trash'         	, component: Trash     , } ,
	{ path: '/settings'      	, component: Settings  , } ,
	{ path: '*'              	, component: Not_Found , } ,
] 

const router = new VueRouter({ routes: routes });

new Vue({
	el: '#app' ,
	router ,
	vuetify ,
	render: h => h(App)
}).$mount('#app')
