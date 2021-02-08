import VueRouter from 'vue-router'
const Register = () => import('./pages/Register');
const Login = () => import('./pages/login');
import NotFound from './components/404'
import AdminDashboard from './pages/admin/Dashboard'
import PenggunaRead from './pages/admin/master_user/Read'
import PenggunaCreate from './pages/admin/master_user/Create'
import PenggunaUpdate from './pages/admin/master_user/Update'

import gantiPassword from './components/gantiPassword'

import AdminAppPenggunaApp from './pages/admin/pengguna_aplikasi/Read'
import AdminAppPenggunaAppNew from './pages/admin/pengguna_aplikasi/Create'
import AdminAppPenggunaAppUpdate from './pages/admin/pengguna_aplikasi/Update'

import AdminAppRole from './pages/admin/role/Read'
import AdminAppRoleNew from './pages/admin/role/Create'
import AdminAppRoleUpdate from './pages/admin/role/Update'
import AdminAppPermission from './pages/admin/permission/Read'

import Divisi from './pages/admin/master_divisi/Read'
import DivisiNew from './pages/admin/master_divisi/Create'
import DivisiUpdate from './pages/admin/master_divisi/Update'

import Jabatan from './pages/admin/master_jabatan/Read'
import JabatanNew from './pages/admin/master_jabatan/Create'
import JabatanUpdate from './pages/admin/master_jabatan/Update'

import Kantor from './pages/admin/master_kantor/Read'
import KantorNew from './pages/admin/master_kantor/Create'
import KantorUpdate from './pages/admin/master_kantor/Update'

import PenerimaanBarang from './pages/admin/penerimaan_barang/Read'
import PenerimaanBarangNew from './pages/admin/penerimaan_barang/Create'
import PenerimaanBarangUpdate from './pages/admin/penerimaan_barang/Update'
import PenerimaanBarangPosting from './pages/admin/penerimaan_barang/Posting'


import Stok from './pages/admin/stok/Read'

import PengeluaranBarang from './pages/admin/pengeluaran_barang/Read'
import PengeluaranBarangNew from './pages/admin/pengeluaran_barang/Create'
import PengeluaranBarangUpdate from './pages/admin/pengeluaran_barang/Update'
import PengeluaranBarangShow from './pages/admin/pengeluaran_barang/Show'

// Routes
const routes = [
    {
        path: '/ganti-password',
        name: 'gantiPassword',
        component: gantiPassword,
        meta: {
            auth: true,
            menus: 'read-404'
        }
    },
    {
        path: '/404',
        name: 'NotFound',
        component: NotFound,
        meta: {
            auth: true,
            menus: 'read-404'
        }
    },
    {
        path: '/register',
        name: 'register',
        component: Register,
        meta: {
            auth: false
        }
    },
    {
        path: '/login',
        name: 'login',
        component: Login,
        meta: {
            auth: false
        }
    },
    // USER ROUTES
    {
        path: '/dashboard',
        name: 'dashboard',
        component: AdminDashboard,
        meta: {
            auth: true,
            menus: 'read-absensi'
        }
    },
    {
        path: '/stok',
        name: 'stok',
        component: Stok,
        meta: {
            auth: true,
            menus: 'read-absensi'
        }
    },
    {
        path: '/pengeluaran_barang',
        name: 'pengeluaran barang',
        component: PengeluaranBarang,
        meta: {
            auth: true,
            menus: 'read-absensi'
        }
    },
    {
        path: '/pengeluaran_barang/create',
        name: 'pengeluaran barang',
        component: PengeluaranBarangNew,
        meta: {
            auth: true,
            menus: 'read-absensi'
        }
    },
    {
        path: '/pengeluaran_barang/:id/show',
        name: 'lihat penerimaan barang',
        component: PengeluaranBarangShow,
        meta: {
            auth: true,
            menus: 'read-absensi'
        }
    },
    {
        path: '/pengeluaran_barang/:id/edit',
        name: 'perbarui penerimaan barang',
        component: PengeluaranBarangUpdate,
        meta: {
            auth: true,
            menus: 'read-absensi'
        }
    },
    {
        path: '/penerimaan_barang',
        name: 'penerimaan barang',
        component: PenerimaanBarang,
        meta: {
            auth: true,
            menus: 'read-absensi'
        }
    },
    {
        path: '/penerimaan_barang/:id/posting',
        name: 'posting penerimaan barang',
        component: PenerimaanBarangPosting,
        meta: {
            auth: true,
            menus: 'read-absensi'
        }
    },
    {
        path: '/penerimaan_barang/create',
        name: 'penerimaan barang',
        component: PenerimaanBarangNew,
        meta: {
            auth: true,
            menus: 'read-absensi'
        }
    },
    {
        path: '/penerimaan_barang/:id/edit',
        name: 'perbarui penerimaan barang',
        component: PenerimaanBarangUpdate,
        meta: {
            auth: true,
            menus: 'read-absensi'
        }
    },
    {
        path: '/user-login',
        name: 'Pengguna Aplikasi',
        component: AdminAppPenggunaApp,
        meta: {
            auth: true,
            menus: 'read-pengguna'
        }
    },
    {
        path: '/user-login/create',
        name: 'Pengguna Aplikasi Baru',
        component: AdminAppPenggunaAppNew,
        meta: {
            auth: true,
            menus: 'create-pengguna'
        }
    },
    {
        path: '/user-login/:id',
        name: 'Perbarui Pengguna Aplikasi',
        component: AdminAppPenggunaAppUpdate,
        meta: {
            auth: true,
            menus: 'edit-pengguna'
        }
    },
    {
        path: '/role',
        name: 'Role',
        component: AdminAppRole,
        meta: {
            auth: true,
            menus: 'read-role'
        }
    },
    {
        path: '/role/create',
        name: 'Role Baru',
        component: AdminAppRoleNew,
        meta: {
            auth: true,
            menus: 'create-role'
        }
    },
    {
        path: '/role/:id',
        name: 'Perbarui Role',
        component: AdminAppRoleUpdate,
        meta: {
            auth: true,
            menus: 'edit-role'
        }
    },
    {
        path: '/permission',
        name: 'Permission',
        component: AdminAppPermission,
        meta: {
            auth: true,
            menus: 'read-pengguna'
        }
    },
    {
        path: '/karyawan',
        name: 'karyawan',
        component: PenggunaRead,
        meta: {
            auth: true,
            menus: 'read-karyawan'
        }
    },
    {
        path: '/karyawan/create',
        name: 'karyawan baru',
        component: PenggunaCreate,
        meta: {
            auth: true,
            menus: 'create-karyawan'
        }
    },
    {
        path: '/karyawan/:id',
        name: 'perbarui karyawan',
        component: PenggunaUpdate,
        meta: {
            auth: true,
            menus: 'edit-karyawan'
        }
    },
    {
        path: '/divisi',
        name: 'Divisi',
        component: Divisi,
        meta: {
            auth: true,
            menus: 'read-divisi'
        }
    },
    {
        path: '/divisi/create',
        name: 'Divisi Baru',
        component: DivisiNew,
        meta: {
            auth: true,
            menus: 'create-divisi'
        }
    },
    {
        path: '/divisi/:id',
        name: 'Perbarui Divisi',
        component: DivisiUpdate,
        meta: {
            auth: true,
            menus: 'edit-divisi'
        }
    },
    {
        path: '/jabatan',
        name: 'Jabatan',
        component: Jabatan,
        meta: {
            auth: true,
            menus: 'read-jabatan'
        }
    },
    {
        path: '/jabatan/create',
        name: 'Jabatan Baru',
        component: JabatanNew,
        meta: {
            auth: true,
            menus: 'create-jabatan'
        }
    },
    {
        path: '/jabatan/:id',
        name: 'Perbarui Jabatan',
        component: JabatanUpdate,
        meta: {
            auth: true,
            menus: 'edit-jabatan'
        }
    },
    {
        path: '/kantor',
        name: 'Kantor',
        component: Kantor,
        meta: {
            auth: true,
            menus: 'read-kantor'
        }
    },
    {
        path: '/kantor/create',
        name: 'Kantor Baru',
        component: KantorNew,
        meta: {
            auth: true,
            menus: 'create-kantor'
        }
    },
    {
        path: '/kantor/:id',
        name: 'Perbarui Kantor',
        component: KantorUpdate,
        meta: {
            auth: true,
            menus: 'edit-kantor'
        }
    },


]
const router = new VueRouter({
    history: true,
    mode: 'history',
    routes,
    linkActiveClass: "active"
})

router.beforeEach((to, from, next) => {
    if (to.name !== 'login' && to.meta.auth == null) {
        if (to.name == 'display') {
            next();

        } else {
            next({ name: 'login' })

        }
    }

    else {
        if (to.fullPath == '/dashboard' && from.fullPath == '/login') {
            next();
            if (!localStorage.getItem('firstLoad')) {
                localStorage['firstLoad'] = true;
                window.location.reload()
            } else {
                localStorage.removeItem('firstLoad');
            }
        } else {
            if (localStorage.auth_stay_signed_in === 'true') {
                var menusRole = to.meta.menus;
                if (jQuery.inArray(menusRole, JSON.parse(localStorage.user)) !== -1) {
                    next();
                } else {
                    next({ name: 'NotFound' });
                }

            } else {
                next();
            }

        }

    }
})



export default router