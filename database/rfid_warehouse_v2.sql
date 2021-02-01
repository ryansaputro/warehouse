-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 01 Feb 2021 pada 03.46
-- Versi server: 10.1.38-MariaDB
-- Versi PHP: 7.3.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rfid_warehouse_v2`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `barang`
--

CREATE TABLE `barang` (
  `id` int(11) NOT NULL,
  `kode_barang` varchar(20) NOT NULL,
  `nama_barang` varchar(100) NOT NULL,
  `id_kategori_barang` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `status_aktif` enum('0','1') NOT NULL COMMENT '1->aktif, 0->tidak aktif',
  `spesifikasi` text NOT NULL,
  `id_satuan_barang_kecil` int(11) NOT NULL,
  `id_satuan_barang_besar` int(11) NOT NULL,
  `fraction` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `barang`
--

INSERT INTO `barang` (`id`, `kode_barang`, `nama_barang`, `id_kategori_barang`, `id_user`, `created_at`, `updated_at`, `status_aktif`, `spesifikasi`, `id_satuan_barang_kecil`, `id_satuan_barang_besar`, `fraction`) VALUES
(1, 'BTL01', 'Botol 600 ml', 1, 5, '2021-01-22 00:00:00', '2021-01-22 00:00:00', '1', 'botol terbuat dari plastik propil etilena 4 yg tidak membahayakan untuk kemasan minuman', 1, 2, 10),
(2, 'BTL02', 'Botol 1000 ml', 1, 5, '2021-01-22 00:00:00', '2021-01-22 00:00:00', '1', 'botol terbuat dari plastik propil etilena 4 yg tidak membahayakan untuk kemasan minuman', 4, 3, 15),
(3, 'BTL03', 'Botol 1500 ml', 1, 5, '2021-01-22 00:00:00', '2021-01-22 00:00:00', '1', 'botol terbuat dari plastik propil etilena 4 yg tidak membahayakan untuk kemasan minuman', 1, 2, 10);

-- --------------------------------------------------------

--
-- Struktur dari tabel `barang_epc_tag`
--

CREATE TABLE `barang_epc_tag` (
  `id` int(11) NOT NULL,
  `epc_tag` varchar(20) NOT NULL,
  `status` enum('0','1') NOT NULL COMMENT '0->tidak aktif, 1->aktif'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `barang_epc_tag`
--

INSERT INTO `barang_epc_tag` (`id`, `epc_tag`, `status`) VALUES
(1, 'ABCD', '1'),
(2, 'EFGH', '1'),
(3, 'IJKL', '1');

-- --------------------------------------------------------

--
-- Struktur dari tabel `barang_kategori`
--

CREATE TABLE `barang_kategori` (
  `id` int(11) NOT NULL,
  `kode_kategori` varchar(10) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL,
  `status_aktif` enum('0','1') NOT NULL,
  `keterangan` text NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `barang_kategori`
--

INSERT INTO `barang_kategori` (`id`, `kode_kategori`, `nama_kategori`, `status_aktif`, `keterangan`, `created_at`, `updated_at`, `id_user`) VALUES
(1, 'BTL', 'botol', '1', 'botol', '2021-01-22 00:00:00', '2021-01-22 00:00:00', 5);

-- --------------------------------------------------------

--
-- Struktur dari tabel `barang_satuan`
--

CREATE TABLE `barang_satuan` (
  `id` int(11) NOT NULL,
  `kode_satuan` varchar(10) NOT NULL,
  `nama_satuan` varchar(100) NOT NULL,
  `status_aktif` enum('0','1') NOT NULL,
  `keterangan` text NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `id_user` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `barang_satuan`
--

INSERT INTO `barang_satuan` (`id`, `kode_satuan`, `nama_satuan`, `status_aktif`, `keterangan`, `created_at`, `updated_at`, `id_user`) VALUES
(1, 'PCS', 'pcs', '1', 'pcs', '2021-01-22 00:00:00', '2021-01-22 00:00:00', 5),
(2, 'BOX10', 'box/10', '1', 'box isi 10', '2021-01-22 00:00:00', '2021-01-22 00:00:00', 5),
(3, 'DUS15', 'Dus/15', '1', 'dus isi 15', '2021-01-26 00:00:00', '2021-01-26 00:00:00', 5),
(4, 'KLG', 'Kaleng', '1', 'kaleng', '2021-01-26 00:00:00', '2021-01-26 00:00:00', 5);

-- --------------------------------------------------------

--
-- Struktur dari tabel `lokasi`
--

CREATE TABLE `lokasi` (
  `id` int(11) NOT NULL,
  `kode` varchar(10) NOT NULL,
  `nama_lokasi` varchar(100) NOT NULL,
  `penanggung_jawab` int(11) NOT NULL,
  `status_aktif` enum('0','1') NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\User', 5),
(1, 'App\\User', 11),
(2, 'App\\User', 8),
(2, 'App\\User', 10),
(2, 'App\\User', 47);

-- --------------------------------------------------------

--
-- Struktur dari tabel `mutasi_barang`
--

CREATE TABLE `mutasi_barang` (
  `id` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `tanggal` datetime NOT NULL,
  `dilakukan_oleh` int(11) NOT NULL,
  `keterangan` text NOT NULL,
  `status` enum('masuk','keluar') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `penerimaan_barang`
--

CREATE TABLE `penerimaan_barang` (
  `id` int(11) NOT NULL,
  `no_penerimaan` varchar(20) NOT NULL,
  `no_purchase_order` varchar(20) NOT NULL,
  `no_spk` varchar(20) NOT NULL,
  `tgl_penerimaan` datetime NOT NULL,
  `id_user` int(11) NOT NULL,
  `status_posting` enum('0','1') NOT NULL,
  `id_vendor` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `penerimaan_barang`
--

INSERT INTO `penerimaan_barang` (`id`, `no_penerimaan`, `no_purchase_order`, `no_spk`, `tgl_penerimaan`, `id_user`, `status_posting`, `id_vendor`, `created_at`, `updated_at`) VALUES
(1, 'Rcv-202101250001', 'PO2021010001', 'SPK2021010001', '2021-01-25 00:00:00', 5, '1', 1, '2021-01-25 04:58:30', '2021-01-25 04:58:30'),
(2, 'Rcv-202101250002', 'PO202101250002', 'SPK2012101250002', '2021-01-25 00:00:00', 5, '0', 2, '2021-01-25 09:17:18', '2021-01-25 09:17:18'),
(3, 'Rcv-202101250003', 'PO202101250003', 'SPK202101250003', '2021-01-25 00:00:00', 5, '1', 1, '2021-01-25 09:27:47', '2021-01-25 09:27:47'),
(4, 'Rcv-202101250004', 'PO202101250004', 'SPK202101250004', '2021-01-25 00:00:00', 5, '0', 2, '2021-01-25 16:31:24', '2021-01-25 16:31:24'),
(5, 'Rcv-202101260005', 'zd', 'sfdsf', '2021-01-26 00:00:00', 5, '1', 1, '2021-01-26 10:06:10', '2021-01-26 10:06:10');

-- --------------------------------------------------------

--
-- Struktur dari tabel `penerimaan_barang_detail`
--

CREATE TABLE `penerimaan_barang_detail` (
  `id` int(11) NOT NULL,
  `id_penerimaan_barang` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `id_satuan_barang_besar` int(11) NOT NULL,
  `id_satuan_barang_kecil` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `keterangan` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `penerimaan_barang_detail`
--

INSERT INTO `penerimaan_barang_detail` (`id`, `id_penerimaan_barang`, `id_barang`, `id_satuan_barang_besar`, `id_satuan_barang_kecil`, `qty`, `keterangan`) VALUES
(1, 1, 1, 2, 2, 20, ''),
(2, 1, 2, 1, 1, 200, ''),
(3, 1, 3, 2, 2, 5, ''),
(4, 2, 1, 2, 2, 10, ''),
(5, 2, 2, 2, 2, 30, ''),
(6, 2, 3, 2, 2, 36, ''),
(7, 3, 1, 1, 1, 100, ''),
(8, 3, 3, 1, 1, 150, ''),
(9, 4, 1, 2, 2, 20, ''),
(10, 4, 2, 2, 2, 30, ''),
(11, 4, 3, 2, 2, 60, ''),
(12, 5, 1, 2, 2, 10, '');

-- --------------------------------------------------------

--
-- Struktur dari tabel `penerimaan_barang_detail_epc_tag`
--

CREATE TABLE `penerimaan_barang_detail_epc_tag` (
  `id` int(11) NOT NULL,
  `id_penerimaan_barang_detail` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `id_epc_tag` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `penerimaan_barang_detail_epc_tag`
--

INSERT INTO `penerimaan_barang_detail_epc_tag` (`id`, `id_penerimaan_barang_detail`, `id_barang`, `id_epc_tag`) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 3, 3);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengeluaran_barang`
--

CREATE TABLE `pengeluaran_barang` (
  `id` int(11) NOT NULL,
  `no_pengeluaran` varchar(10) NOT NULL,
  `id_user` int(11) NOT NULL,
  `tanggal_pengeluaran` datetime NOT NULL,
  `id_unit_pengirim` int(11) NOT NULL,
  `id_unit_penerima` int(11) NOT NULL,
  `status_posting` enum('0','1') NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengeluaran_barang_detail`
--

CREATE TABLE `pengeluaran_barang_detail` (
  `id` int(11) NOT NULL,
  `id_pengeluaran` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `id_satuan_barang_besar` int(11) NOT NULL,
  `id_satuan_barang_kecil` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `keterangan` text NOT NULL,
  `id_epc_tag` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'read-absensi', 'web', '2020-08-31 18:49:26', '2020-08-31 18:49:26'),
(2, 'read-pengguna', 'web', '2020-09-01 19:57:18', '2020-09-01 19:57:18'),
(3, 'create-pengguna', 'web', '2020-09-01 19:57:19', '2020-09-01 19:57:19'),
(4, 'edit-pengguna', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(5, 'delete-pengguna', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(6, 'read-404', 'web', '2020-09-01 19:57:21', '2020-09-01 19:57:21'),
(7, 'dashboard-total-karyawan', 'web', '2020-09-01 19:57:18', '2020-09-01 19:57:18'),
(8, 'dashboard-kehadiran', 'web', '2020-09-01 19:57:19', '2020-09-01 19:57:19'),
(9, 'dashboard-keterlambatan', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(10, 'read-data-kehadiran', 'web', '2020-09-01 19:57:18', '2020-09-01 19:57:18'),
(11, 'create-data-kehadiran', 'web', '2020-09-01 19:57:19', '2020-09-01 19:57:19'),
(12, 'edit-data-kehadiran', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(13, 'delete-data-kehadiran', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(14, 'read-lacak', 'web', '2020-08-31 18:49:26', '2020-08-31 18:49:26'),
(15, 'read-pantau', 'web', '2020-09-01 19:57:18', '2020-09-01 19:57:18'),
(16, 'export-pdf-laporan-absensi', 'web', '2020-08-31 18:49:26', '2020-08-31 18:49:26'),
(17, 'export-xls-laporan-absensi', 'web', '2020-08-31 18:49:26', '2020-08-31 18:49:26'),
(18, 'export-pdf-rekap-absensi', 'web', '2020-08-31 18:49:26', '2020-08-31 18:49:26'),
(19, 'export-xls-rekap-absensi', 'web', '2020-08-31 18:49:26', '2020-08-31 18:49:26'),
(20, 'export-pdf-rekap-keterlambatan', 'web', '2020-08-31 18:49:26', '2020-08-31 18:49:26'),
(21, 'export-xls-rekap-keterlambatan', 'web', '2020-08-31 18:49:26', '2020-08-31 18:49:26'),
(22, 'read-karyawan', 'web', '2020-09-01 19:57:18', '2020-09-01 19:57:18'),
(23, 'create-karyawan', 'web', '2020-09-01 19:57:19', '2020-09-01 19:57:19'),
(24, 'edit-karyawan', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(25, 'delete-karyawan', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(26, 'read-role', 'web', '2020-09-01 19:57:18', '2020-09-01 19:57:18'),
(27, 'create-role', 'web', '2020-09-01 19:57:19', '2020-09-01 19:57:19'),
(28, 'edit-role', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(29, 'delete-role', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(30, 'read-lokasi', 'web', '2020-09-01 19:57:18', '2020-09-01 19:57:18'),
(31, 'create-lokasi', 'web', '2020-09-01 19:57:19', '2020-09-01 19:57:19'),
(32, 'edit-lokasi', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(33, 'delete-lokasi', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(34, 'read-divisi', 'web', '2020-09-01 19:57:18', '2020-09-01 19:57:18'),
(35, 'create-divisi', 'web', '2020-09-01 19:57:19', '2020-09-01 19:57:19'),
(36, 'edit-divisi', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(37, 'delete-divisi', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(38, 'read-jabatan', 'web', '2020-09-01 19:57:18', '2020-09-01 19:57:18'),
(39, 'create-jabatan', 'web', '2020-09-01 19:57:19', '2020-09-01 19:57:19'),
(40, 'edit-jabatan', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(41, 'delete-jabatan', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(42, 'read-kantor', 'web', '2020-09-01 19:57:18', '2020-09-01 19:57:18'),
(43, 'create-kantor', 'web', '2020-09-01 19:57:19', '2020-09-01 19:57:19'),
(44, 'edit-kantor', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20'),
(45, 'delete-kantor', 'web', '2020-09-01 19:57:20', '2020-09-01 19:57:20');

-- --------------------------------------------------------

--
-- Struktur dari tabel `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'superadmin', 'web', '2020-08-31 18:42:38', '2020-08-31 18:42:38'),
(2, 'hrd', 'web', '2020-08-31 18:45:16', '2020-10-01 19:01:24');

-- --------------------------------------------------------

--
-- Struktur dari tabel `role_has_menus`
--

CREATE TABLE `role_has_menus` (
  `id` int(11) NOT NULL,
  `id_role` int(11) NOT NULL,
  `menus` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `role_has_menus`
--

INSERT INTO `role_has_menus` (`id`, `id_role`, `menus`) VALUES
(1, 1, '[{\"href\":\"\\/dashboard\",\"title\":\"Dashboard\",\"icon\":\"fa fa-area-chart\"},\r\n    {\"href\":\"\\/penerimaan_barang\",\"title\":\"Penerimaan Barang\",\"icon\":\"fa fa-angle-double-down\"},\r\n    {\"href\":\"\\/pengeluaran_barang\",\"title\":\"Pengeluaran Barang\",\"icon\":\"fa fa-angle-double-up\"},\r\n    {\"href\":\"\\/posting_stok\",\"title\":\"Posting Stok\",\"icon\":\"fa fa-paper-plane\"},\r\n    {\"href\":\"\\/stok\",\"title\":\"Stok\",\"icon\":\"fa fa-list-alt\"},\r\n    {\"title\":\"Laporan\",\"icon\":\"fa fa-book\",\r\n        \"child\":[\r\n            {\"href\":\"\\/laporan-absensi\",\"title\":\"Laporan Kehadiran\"},\r\n            {\"href\":\"\\/rekap-absensi\",\"title\":\"Rekap Absensi\"},\r\n            {\"href\":\"\\/rekap-keterlambatan\",\"title\":\"Rekap Keterlambatan\"}\r\n        ]\r\n    },\r\n    {\"title\":\"Master Data\",\"icon\":\"fa fa-database\",\r\n        \"child\":[\r\n            {\"href\":\"\\/karyawan\",\"title\":\"Karyawan\"},\r\n            {\"href\":\"\\/lokasi\",\"title\":\"Lokasi\"},\r\n            {\"href\":\"\\/divisi\",\"title\":\"Divisi\"},\r\n            {\"href\":\"\\/jabatan\",\"title\":\"Jabatan\"},\r\n            {\"href\":\"\\/kantor\",\"title\":\"Kantor\"}\r\n        ]\r\n    },\r\n    {\"title\":\"Admin Aplikasi\",\"icon\":\"fa fa-desktop\",\r\n        \"child\":[\r\n            {\"href\":\"\\/user-login\",\"title\":\"Pengguna Aplikasi\"},\r\n            {\"href\":\"\\/role\",\"title\":\"Role\"}\r\n        ]\r\n    }]'),
(2, 2, '[{\"href\":\"\\/dashboard\",\"title\":\"Dashboard\",\"icon\":\"fa fa-area-chart\"},{\"href\":\"\\/absensi\",\"title\":\"Absensi\",\"icon\":\"fa fa-user\"},{\"href\":\"\\/lacak\",\"title\":\"Lacak Personnel\",\"icon\":\"fa fa-blind\"},{\"href\":\"\\/pantau\",\"title\":\"Pantau Personnel\",\"icon\":\"fa fa-eye\"},{\"href\":\"\\/data-kehadiran\",\"title\":\"Data Kehadiran\",\"icon\":\"fa fa-calendar\"},{\"title\":\"Laporan\",\"icon\":\"fa fa-book\",\"child\":[{\"href\":\"\\/laporan-absensi\",\"title\":\"Laporan Kehadiran\"},{\"href\":\"\\/rekap-absensi\",\"title\":\"Rekap Absensi\"},{\"href\":\"\\/rekap-keterlambatan\",\"title\":\"Rekap Keterlambatan\"}]}]');

-- --------------------------------------------------------

--
-- Struktur dari tabel `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(6, 2),
(7, 1),
(7, 2),
(8, 1),
(8, 2),
(9, 1),
(9, 2),
(10, 1),
(10, 2),
(11, 1),
(11, 2),
(12, 1),
(12, 2),
(13, 1),
(13, 2),
(14, 1),
(14, 2),
(15, 1),
(15, 2),
(16, 1),
(16, 2),
(17, 1),
(17, 2),
(18, 1),
(18, 2),
(19, 1),
(19, 2),
(20, 1),
(20, 2),
(21, 1),
(21, 2),
(22, 1),
(23, 1),
(24, 1),
(25, 1),
(26, 1),
(27, 1),
(28, 1),
(29, 1),
(30, 1),
(31, 1),
(32, 1),
(33, 1),
(34, 1),
(35, 1),
(36, 1),
(37, 1),
(38, 1),
(39, 1),
(40, 1),
(41, 1),
(42, 1),
(43, 1),
(44, 1),
(45, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `stok_barang`
--

CREATE TABLE `stok_barang` (
  `id` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `id_unit` int(11) NOT NULL,
  `id_gudang` int(11) NOT NULL,
  `qty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `stok_barang`
--

INSERT INTO `stok_barang` (`id`, `id_barang`, `id_unit`, `id_gudang`, `qty`) VALUES
(1, 1, 1, 1, 500),
(2, 2, 1, 1, 150),
(3, 3, 3, 1, 350);

-- --------------------------------------------------------

--
-- Struktur dari tabel `unit`
--

CREATE TABLE `unit` (
  `id` int(11) NOT NULL,
  `kode` varchar(10) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `status` enum('0','1') NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nik_pegawai` varchar(17) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nik_ktp` varchar(17) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_divisi` int(11) NOT NULL,
  `id_jabatan` int(11) NOT NULL,
  `nama_lengkap` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gol_darah` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_telp` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa',
  `id_epc_tag` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `nik_pegawai`, `nik_ktp`, `id_divisi`, `id_jabatan`, `nama_lengkap`, `gol_darah`, `no_telp`, `email`, `email_verified_at`, `password`, `id_epc_tag`, `foto`, `remember_token`, `created_at`, `updated_at`) VALUES
(5, '', '', 1, 0, 'Super Admin', 'O', '085654343456', 'superadmin@gmail.com', NULL, '$2y$10$GrcRMoq8LOFLlWwJmkVx..kzmdm6S6qC4YcYOUXKIOmw2CYeD2yOC', '35882250-', '', NULL, '2020-08-24 19:57:46', '2020-10-01 19:24:22'),
(8, '19-2-086', '3207011804960002', 1, 1, 'Ilman H Oriza', 'B', '085645432345', 'ilmanhilmioriza@gmail.com', NULL, '$2y$10$97VoAkDw1svmdyN2a4h6VeBENA0TutE3vLdRagu42FPzezfNfN3.6', 'ED783737', 'ILMAN_H_ORIZA.jpg', NULL, NULL, '2020-10-23 01:17:46'),
(10, '06-2-008', '3217092010840016', 1, 7, 'Hendra Wijaksana O.', 'AB', '081931444594', 'hwijaksana@gmail.com', NULL, '$2y$10$97VoAkDw1svmdyN2a4h6VeBENA0TutE3vLdRagu42FPzezfNfN3.6', 'CF762374', 'HENDRA_WIJAKSANA_O..jpg', NULL, NULL, '2020-10-26 02:12:13'),
(11, '19-2-083', '3212150705960003', 1, 1, 'Mohamad Reza Aditya Putra', 'A', '085659515708', 'mohrezaadityap@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'CF762494', 'MOHAMAD_REZA_ADITYA_PUTRA.jpeg', NULL, NULL, '2020-10-23 01:51:01'),
(12, '19-2-084', '3520150204950003', 1, 1, 'Ryan Saputro', 'O', '085649184363', 'ryansaputro52@gmail.com', NULL, '$2y$10$97VoAkDw1svmdyN2a4h6VeBENA0TutE3vLdRagu42FPzezfNfN3.6', 'BA991D9C', 'RYAN_SAPUTRO.jpg', NULL, NULL, '2020-11-04 00:32:03'),
(13, '19-5-007', '3273070701940001', 1, 2, 'Imam Rohiman', 'O', '086545432345', 'rohimanimam@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'ED782987', 'IMAM_ROHIMAN.jpg', NULL, NULL, '2020-10-26 01:33:57'),
(14, '19-5-008', '3273141609930004', 1, 3, 'Agus Septian Heryanto', 'A', '089690596772', 'agusindonesiancycling8@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'ED74C617', 'AGUS_SEPTIAN_HERYANTO.jpg', NULL, NULL, '2020-10-26 02:56:02'),
(15, '19-5-011', '3204151510950010', 1, 4, 'Fahmi Syanizar Naufal', 'O', '089655970776', 'fahmiyami@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'ED783547', 'FAHMI_SYANIZAR_NAUFAL.jpg', NULL, NULL, '2020-10-26 02:56:26'),
(16, '20-2-095', '3277035010960005', 5, 5, 'Anditasari Nur Muslimah', 'B', '087730818877', 'anditasarinur@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'ED783657', 'ANDITASARI_NUR_MUSLIMAH.jpg', NULL, NULL, '2020-10-23 01:49:37'),
(17, '20-2-097', '3273075706970007', 5, 5, 'Imas Nurzanah', 'O', '086544143647', 'imasnurzanah@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'ED6E4907', 'IMAS_NURZANAH.jpg', NULL, NULL, '2020-10-23 01:50:00'),
(18, '04-4-005', '3273091706680002', 4, 6, 'Akhmad Baehaki', 'B', '081322815334', 'akhmadbaehaki@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'CF73B784', 'AKHMAD_BAEHAKI.jpg', NULL, NULL, '2020-10-26 02:02:08'),
(19, '95-4-001', '3204081606710005', 4, 7, 'Tahyudin', 'O', '082130145845', 'udin_esse@yahoo.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'CF780204', 'TAHYUDIN.jpg', NULL, NULL, '2020-11-12 19:23:25'),
(20, '06-4-008', '3204120402810005', 4, 8, 'Eko Arthanto Susilo', 'A', '082214424481', 'e45_te@yahoo.co.id', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'CF762364', 'EKO_ARTHANTO_SUSILO.jpg', NULL, NULL, '2020-10-23 01:39:31'),
(21, '19-4-023', '3205146511450003', 4, 8, 'Siti Nurhasanah', 'O', '082316001829', 'sn9383551@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'ED7AB877', 'SITI_NURHASANAH.jpg', NULL, NULL, '2020-10-23 01:39:55'),
(22, '91-1-002', '3217096404900005', 2, 6, 'Budi Hermawan', 'O', '08122022161', 'budiheran@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'ED783727', 'BUDI_HERMAWAN.jpg', NULL, NULL, '2020-10-26 02:07:12'),
(23, '13-3-008', '3277032802720017', 2, 10, 'Nur Aeni', 'O', '082115454415', 'nuraeni_114@yahoo.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'CF6E0194', 'NUR_AENI.jpg', NULL, NULL, '2020-10-23 01:40:17'),
(24, '04-2-005', '3204050109800002', 2, 11, 'Yosep Wijaya R.', 'A', '081123123123', 'jos_wr@yahoo.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'CF7625B4', 'YOSEP_WIJAYA_R..jpg', NULL, NULL, '2020-11-15 19:28:33'),
(25, '17-2-067', '3204102607940006', 2, 12, 'Faisal Gani', 'B', '081546995801', 'faisalgani23@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'ED740C17', 'FAISAL_GANI.jpg', NULL, NULL, '2020-11-12 19:11:31'),
(26, '15-2-056', '3273162102950002', 2, 12, 'Aditya Iqbal Fermadi', 'B', '082216717607', 'adityaiqbal70@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'CF6DC8D4', 'ADITYA_IQBAL_FERMADI.jpg', NULL, NULL, '2020-10-23 01:41:03'),
(27, '15-3-011', '3213121901900005', 2, 13, 'Dang Herman', 'B', '082144100110', 'dangh3rman@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'CF741B54', 'DANG_HERMAN.jpg', NULL, NULL, '2020-10-26 02:26:25'),
(28, '15-3-013', '3204052710920013', 2, 14, 'Muhammad Reza Nugraha', 'AB', '089608979341', 'ezanugraha92@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'ED7ABF67', 'MUHAMMAD_REZA_NUGRAHA.jpg', NULL, NULL, '2020-10-26 02:27:01'),
(29, '07-3-003', '3204292010840008', 2, 15, 'Mulkanudin', 'B', '081298685003', 'mulkan84@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'ED704447', 'MULKANUDIN.jpg', NULL, NULL, '2020-10-23 01:43:41'),
(30, '18-2-079', '3273204603950001', 2, 10, 'Dinar Sriwidya', 'AB', '083829521551', 'dinarsriwidya6@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'ED7A2B47', 'DINAR_SRIWIDYA.jpg', NULL, NULL, '2020-10-23 01:43:59'),
(31, '14-2-045', '3279020202920003', 2, 16, 'Murdiana', 'A', '082251076543', 'murdianasanjaya@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', 'ED6EE857', 'MURDIANA.jpg', NULL, NULL, '2020-10-23 01:44:48'),
(33, '20-2-099', '3273222108960004', 2, 12, 'Angga Pratama Rahmanto', 'B', '082240200649', 'anggapcaw@gmail.com', NULL, '', 'ED7622F7', 'ANGGA_PRATAMA_RAHMANTO.jpg', NULL, '2020-09-29 20:56:58', '2020-10-23 01:42:40'),
(34, '20-2-100', '3202051011980006', 2, 12, 'Sukron Alkholiq', 'AB', '085710551520', 'salkholiq@gmail.com', NULL, '', 'ED76DEF7', 'SUKRON_ALKHOLIQ.jpg', NULL, '2020-09-29 20:59:58', '2020-10-23 01:42:55'),
(35, '20-2-108', '3210042104960042', 2, 12, 'Ilham Fauzan Ramandha', 'A', '081394459298', 'ramandha.fr@gmail.com', NULL, '', 'ED78F1E7', 'ILHAM_FAUZAN_RAMANDHA.jpg', NULL, '2020-09-29 21:05:39', '2020-10-26 02:24:33'),
(37, '15-2-051', '3211132202930005', 2, 16, 'Riky Anugrah', 'B', '083132047001', 'rikyanugrah326@gmail.com', NULL, '', 'CF6C5CD4', 'RIKY_ANUGRAH.jpg', NULL, '2020-09-29 21:11:02', '2020-10-26 02:41:25'),
(39, '18-2-081', '3272061406950021', 2, 16, 'Witura Fajar Abdulgani', 'O', '089636646507', 'wituraajay@gmail.com', NULL, '', 'ED720EC7', 'WITURA_FAJAR_ABDULGANI.jpg', NULL, '2020-09-29 21:14:56', '2020-10-23 01:59:12'),
(40, '20-2-096', '1205020304970001', 2, 16, 'Ananda Sahputra', 'A', '081269532568', 'anandasahputra9797@gmail.com', NULL, '', 'ED704087', 'ANANDA_SAHPUTRA.jpg', NULL, '2020-09-29 21:17:03', '2020-10-23 01:45:43'),
(44, '20-2-105', '320413310940006', 2, 16, 'Jody Megatama', 'B', '082298137570', 'jodimegatama@gmail.com', NULL, '', 'ED7A2B37', 'JODY_MEGATAMA.jpg', NULL, '2020-09-29 21:26:48', '2020-10-23 01:46:10'),
(45, '20-2-110', '3273010603960004', 2, 16, 'Fauzani Rohman', 'AB', '081213903540', 'fauzanirohman@gmail.com', NULL, '', 'ED7622E7', 'FAUZANI_ROHMAN.jpg', NULL, '2020-09-29 21:28:34', '2020-10-23 01:46:27'),
(46, '20-2-113', '3522010101920002', 2, 16, 'Anang Hadi', 'O', '085745118131', 'ananghadi1992@gmail.com', NULL, '', '300.3565869064597', 'ANANG_HADI.jpg', NULL, '2020-09-29 21:30:12', '2020-11-04 18:45:37'),
(47, '19-4-022', '3273167110890002', 6, 7, 'Olvy Raindri Yustiani', 'O', '081809401526', 'olvyyustiani216@gmail.com', NULL, '$2y$10$97VoAkDw1svmdyN2a4h6VeBENA0TutE3vLdRagu42FPzezfNfN3.6', 'ED7837C7', 'OLVY_RAINDRI_YUSTIANI.jpg', NULL, '2020-09-29 23:35:40', '2020-10-23 01:55:06'),
(48, '16-4-016', '3273165807880007', 6, 17, 'Risa Setiani Yulia', 'O', '082120181188', 'Risasetianiyulia@gmail.com', NULL, '', 'CF71FBD4', 'RISA_SETIANI_YULIA.png', NULL, '2020-09-29 23:37:35', '2020-10-23 01:55:45'),
(49, '02-4-004', '3273142209760003', 6, 18, 'Ramdani', 'O', '08568457644', 'jangdani@yahoo.com', NULL, '', 'ED740B67', 'RAMDANI.jpg', NULL, '2020-09-29 23:46:41', '2020-10-23 01:47:03'),
(50, '02-4-003', '3217011206830015', 6, 18, 'Ucha Nursalehman', 'B', '081320397198', 'maruca_n83@yahoo.co.id', NULL, '', 'ED7211F7', 'UCHA_NURSALEHMAN.jpg', NULL, '2020-09-29 23:48:58', '2020-10-26 02:27:50'),
(51, '06-4-007', '3273120202860003', 6, 18, 'Pian Septian', 'O', '085722269371', 'putrawahidseptian@gmail.com', NULL, '', 'ED74C937', 'PIAN_SEPTIAN.jpg', NULL, '2020-09-29 23:50:48', '2020-10-26 02:41:54'),
(52, '16-4-015', '3273081307780006', 6, 18, 'Taufik Rachman', 'O', '081312502651', 'rachmantaufik78@gmail.com', NULL, '', 'CF7801F4', 'TAUFIK_RACHMAN.jpg', NULL, '2020-09-29 23:53:07', '2020-10-23 01:48:31'),
(53, '03-2-004', '3273270505790002', 5, 19, 'Wahyudin', 'A', '08179280289', 'wahyu_alfarizi@yahoo.com', NULL, '', 'CF6FEFB4', 'WAHYUDIN.jpg', NULL, '2020-09-30 00:03:35', '2020-11-16 20:51:40'),
(54, '14-2-038', '3273200810800000', 5, 5, 'Wahyu Nugroho', 'A', '081931383908', 'romeoblue@gmail.com', NULL, '', 'ED7C3A37', 'WAHYU_NUGROHO.jpg', NULL, '2020-09-30 00:05:16', '2020-10-27 19:14:31'),
(55, '94-2-001', '1050012704713005', 1, 1, 'Ali Hanafiah A.', 'A', '089515523376', 'ali@nuansa.com', NULL, '', 'ED7C2997', 'ALI_HANAFIAH_A..jpg', NULL, '2020-09-30 00:20:45', '2020-10-23 01:54:44'),
(56, '20-06-114', '123456789012345', 1, 5, 'Aris Yunanto', 'O', '081315937266', 'arisyunantoaris@gmail.com', NULL, '', 'ED6EEC87', 'ARIS_YUNANTO.jpg', NULL, '2020-09-30 00:22:54', '2020-10-26 02:41:08'),
(57, '03-2-003', '3578081402630003', 7, 6, 'Hardianto', 'B', '082244145665', 'hardianto_surabaya@yahoo.com', NULL, '', '300.2052921850284', 'HARDIANTO.jpg', NULL, '2020-09-30 00:46:05', '2020-10-22 01:10:47'),
(58, '10-2-014', '3578086509800002', 7, 10, 'Wiwien Risnawati', 'B', '081330262692', 'wiwien_boby@yahoo.co.id', NULL, '', '300.2761005696618', 'WIWIEN_RISNAWATI.jpg', NULL, '2020-09-30 00:48:01', '2020-10-21 19:23:46'),
(59, '14-4-014', '3524131706950005', 7, 18, 'Angger Dadang', 'O', '085746225295', 'dadang_nazrielilham@yahoo.co.id', NULL, '', '300.7646263239576', 'ANGGER_DADANG.jpg', NULL, '2020-09-30 00:49:50', '2020-10-26 02:53:41'),
(61, '19-2-087', '3515130901950002', 7, 5, 'Reza Djanuar', 'O', '082146032982', 'reza.djanuar@gmail.com', NULL, '', '300.9948299415361', 'REZA_DJANUAR.jpg', NULL, '2020-09-30 00:53:44', '2020-10-22 01:12:35'),
(62, '12-2-022', '3525136909900003', 7, 5, 'Widia Kurniawati', 'O', '082234487796', 'widia_9022@yahoo.com', NULL, '', '300.68027076654164', 'WIDIA_KURNIAWATI.jpg', NULL, '2020-09-30 00:56:12', '2020-10-22 01:20:12'),
(63, '12-2-016', '3519152206880001', 7, 7, 'Aan Ari Fahrudin', 'O', '085651013683', 'aringgaseta5@yahoo.co.id', NULL, '', 'ED6EEC87', 'AAN_ARI_FAHRUDIN.jpg', NULL, '2020-09-30 00:57:53', '2020-10-30 03:05:42'),
(64, '11-2-015', '3528020504850003', 7, 1, 'Erwin Apriliyanto', 'B', '085755456650', 'erwins388@yahoo.com', NULL, '', '300.04350792527526', 'ERWIN_APRILIYANTO.jpg', NULL, '2020-09-30 00:59:28', '2020-10-22 01:45:20'),
(65, '07-2-010', '3571020107770090', 7, 1, 'Dwie Prasetyo', 'AB', '081231309466', 'dwie_pras_sda@yahoo.com', NULL, '', '300.96694754061', 'DWIE_PRASETYO.jpg', NULL, '2020-09-30 01:01:17', '2020-10-20 03:02:00'),
(66, '19-2-090', '3524050109940004', 7, 1, 'M. Hudi Asrori', 'O', '085745135074', 'hudiasrori69@gmail.com', NULL, '', '300.70421395795813', 'M._HUDI_ASRORI.jpg', NULL, '2020-09-30 01:03:03', '2020-10-26 02:10:49'),
(67, '15-2-058', '3578080502800001', 7, 16, 'Achmad Sulthoni', 'O', '081246009969', 'achmadsulthoni@gmail.com', NULL, '', '123456', 'ACHMAD_SULTHONI.jpg', NULL, '2020-09-30 01:05:20', '2020-10-21 19:42:12'),
(68, '06-2-009', '6371012705800010', 7, 16, 'Yatna Priatna', 'AB', '0817207725', 'yatna27@yahoo.com', NULL, '', '300.9884941503298', 'YATNA_PRIATNA.jpg', NULL, '2020-09-30 01:07:17', '2020-10-21 19:38:15'),
(70, '19-2-085', '3328121108940004', 7, 16, 'Agung Prasetya', 'B', '085741160560', 'prasetya278@gmail.com', NULL, '', '300.0817891863005', 'AGUNG_PRASETYA.jpg', NULL, '2020-09-30 01:11:23', '2020-10-21 23:21:17'),
(71, '19-2-089', '3205131005930004', 7, 16, 'Ade Sukur', 'O', '081321909129', 'adesyukur@gmail.com', NULL, '', '300.4434635112467', 'ADE_SUKUR.jpg', NULL, '2020-09-30 01:13:23', '2020-10-21 19:43:29'),
(72, '19-2-093', '6371031302960008', 7, 16, 'M. Ramadhani', 'A', '082315210029', 'ramadhanim1996@gmail.com', NULL, '', '300.9719500280655', 'M._RAMADHANI.jpg', NULL, '2020-09-30 01:15:11', '2020-10-22 01:03:49'),
(73, '19-2-094', '3329142404970004', 7, 16, 'R. Miqo Mahardhika', 'AB', '087822765873', 'miqo304@hotmail.com', NULL, '', '300.5293596373213', 'R._MIQO_MAHARDHIKA.jpg', NULL, '2020-09-30 01:17:01', '2020-10-21 23:34:23'),
(74, '20-2-098', '3204293004980004', 7, 16, 'Sugiharto', 'B', '081476642280', 'hartos335@gmail.com', NULL, '', '300.73094813314356', 'SUGIHARTO.jpg', NULL, '2020-09-30 01:19:12', '2020-10-22 01:13:36'),
(75, '20-2-109', '3273160806950002', 7, 16, 'Andika Rizki H', 'O', '082116086791', 'andikarizkih@gmail.com', NULL, '', '300.06666178448745', 'ANDIKA_RIZKI_H.jpg', NULL, '2020-09-30 01:20:56', '2020-10-21 23:27:36'),
(76, '20-2-111', '3212031512960003', 7, 16, 'Aditya Sofyan Hidayatullah', 'O', '082119525096', 'aditsof@gmail.com', NULL, '', '300.1404645537403', 'ADITYA_SOFYAN_HIDAYATULLAH.jpg', NULL, '2020-09-30 01:22:21', '2020-10-21 19:47:03'),
(77, '20-2-112', '81020122501980001', 7, 16, 'Fransiscus Alfino Ohoilulin', 'O', '082248019484', 'ohoilulinalfino@gmail.com', NULL, '', '300.5023374459728', 'FRANSISCUS_ALFINO_OHOILULIN.jpg', NULL, '2020-09-30 01:24:53', '2020-10-22 01:08:54'),
(78, '91-2-000', '3207011804960002', 1, 6, 'Sigit Wiriyatmo', 'A', '08122047501', 'sigit@nuansa.com', NULL, '$2y$10$97VoAkDw1svmdyN2a4h6VeBENA0TutE3vLdRagu42FPzezfNfN3.6', 'ED6EEBB7', 'SIGIT_WIRIYATMO.jpg', NULL, NULL, '2020-10-23 01:38:13'),
(79, '19-2-001', '3273016310970002', 1, 5, 'Selina astiri', 'A', '089537922810', 'selinaastiri23@gmail.com', NULL, '$2y$10$97VoAkDw1svmdyN2a4h6VeBENA0TutE3vLdRagu42FPzezfNfN3.6', 'ED78E0C7', 'SELINA_ASTIRI.jpg', NULL, NULL, '2020-10-26 02:18:39'),
(80, '06-2-007', '3525160912810124', 7, 19, 'M. Chusni Mubaroq', 'O', '082291700429', 'emailku_free@yahoo.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', '12345678', 'M._CHUSNI_MUBAROQ.jpeg', NULL, '2020-10-27 01:13:05', '2020-11-03 21:12:13'),
(83, '20-2-115', '3329090807950005', 7, 16, 'WAHYUDIN', 'AB', '087705114085', '160613056WAHYUDIN@GMAIL.COM', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', '12345', 'WAHYUDIN.jpeg', NULL, '2020-10-27 23:56:17', '2020-10-27 23:56:17'),
(84, '20-2-114', '5309081409880001', 7, 16, 'Yohanes Krisostomus Deru', 'A', '082138407205', 'jironariel75@gmail.com', NULL, '$2y$10$6oOf6pDJY39NddoQzJ/uEucR4/7E.IxIzIzJOlbXb/Q3JoLvuGtYa', '123456789', 'YOHANES_KRISOSTOMUS_DERU.jpeg', NULL, '2020-10-27 23:48:08', '2020-10-27 23:48:08');

--
-- Trigger `users`
--
DELIMITER $$
CREATE TRIGGER `delete_to_log` AFTER DELETE ON `users` FOR EACH ROW BEGIN
        INSERT INTO log_data 
            (`id_data`, `field`, `status`)  
        VALUES 
            (OLD.id, "users", "delete");
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_to_log` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
        INSERT INTO log_data 
            (`id_data`, `field`, `status`)  
        VALUES 
            (NEW.id, "users", "INSERT");
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_to_log` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
        INSERT INTO log_data
            (`id_data`, `field`, `status`)  
        VALUES 
            (OLD.id, "users", "update");
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users_alamat`
--

CREATE TABLE `users_alamat` (
  `id` int(11) NOT NULL,
  `id_karyawan` int(11) NOT NULL,
  `rt` varchar(3) NOT NULL,
  `rw` varchar(3) NOT NULL,
  `kelurahan` varchar(15) NOT NULL,
  `kecamatan` int(10) NOT NULL,
  `kota` int(10) NOT NULL,
  `provinsi` int(10) NOT NULL,
  `kode_pos` int(5) NOT NULL,
  `alamat` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `users_alamat`
--

INSERT INTO `users_alamat` (`id`, `id_karyawan`, `rt`, `rw`, `kelurahan`, `kecamatan`, `kota`, `provinsi`, `kode_pos`, `alamat`) VALUES
(1, 33, '002', '003', '3273090003', 3273090, 3273, 32, 40286, 'JL YUPITER SELATAN I NO. 3'),
(2, 34, '002', '005', '3202290019', 3202290, 3202, 32, 43366, 'KP CIMAREME'),
(3, 35, '017', '006', '3210040009', 3210040, 3210, 32, 45463, 'BLOK KAUMKALER NO 349'),
(5, 37, '001', '006', '3211032005', 3211032, 3211, 32, 45365, 'DSN HAMPANG'),
(7, 39, '010', '001', '3273060001', 3273060, 3273, 32, 40255, 'JL SRIWIJAYA BABAKAN PRIANGAN'),
(8, 40, '000', '000', '1213021005', 1213021, 1213, 12, 20773, 'DUSUN HALBAN'),
(12, 44, '004', '007', '3204160006', 3204160, 3204, 32, 40377, 'MARGAHURIP ASIH'),
(13, 45, '001', '010', '3273250001', 3273250, 3273, 32, 40151, 'KP CIJEROKASO'),
(14, 46, '016', '005', '3522020015', 3522020, 3522, 35, 62165, 'KEDUNG RINGIN'),
(15, 47, '008', '010', '3273150003', 3273150, 3273, 32, 40286, 'KPAD PINDAD UTARA K 2241'),
(16, 48, '003', '006', '3273150003', 3273150, 3273, 32, 40286, 'JL KEBONJAYANTI NO. 86'),
(17, 49, '004', '024', '3204290002', 3204290, 3204, 32, 40264, 'komp permata biru AF no 2'),
(18, 50, '006', '029', '3204290003', 3204290, 3204, 32, 40263, 'komp permata biru T2/65'),
(19, 51, '001', '002', '3273160002', 3273160, 3273, 32, 40275, 'JL BINONG TENGAH'),
(20, 52, '005', '001', '3273260002', 3273260, 3273, 32, 40142, 'KP BENGKOK'),
(21, 53, '007', '014', '3273101003', 3273101, 3273, 32, 40295, 'Jl Riung Gede Permai blof F no 10'),
(22, 54, '005', '007', '3273141001', 3273141, 3273, 32, 40291, 'PERUMAHAN BELLEZA KAV A-12'),
(23, 55, '001', '002', '1971040023', 1971040, 1971, 19, 33125, 'JL SUMEDANG NO. 157'),
(24, 56, '003', '008', '3273160007', 3273160, 3273, 32, 40271, 'JL JAKARTA NO 11'),
(25, 57, '005', '001', '3578100005', 3578100, 3578, 35, 60286, 'DHARMAWANGSA 4/21'),
(26, 58, '001', '007', '3578100006', 3578100, 3578, 35, 60285, 'KARANG MENJANGAN 1-A/61'),
(27, 59, '008', '001', '3524110016', 3524110, 3524, 35, 62257, 'PADENGANPLOSO'),
(29, 61, '006', '002', '3515160016', 3515160, 3515, 35, 61257, 'GRIYO WAGE ASRI BLOK M 16'),
(30, 62, '018', '005', '3525040006', 3525040, 3525, 35, 61174, 'BALONG DINDING'),
(31, 63, '002', '002', '3520060017', 3520060, 3520, 35, 63316, 'jl. Cempaka 20'),
(32, 64, '002', '001', '3528020016', 3528020, 3528, 35, 69323, 'DSN MURTAJIH'),
(33, 65, '001', '011', '3515060015', 3515060, 3515, 35, 61272, 'PR. PURI SAMPOERNO'),
(34, 66, '001', '004', '3524100004', 3524100, 3524, 35, 62271, 'JL PENDIDIKAN'),
(35, 67, '008', '002', '3578100005', 3578100, 3578, 35, 60286, 'Gubeng Airlangga 5/6-A'),
(36, 68, '023', '008', '6371010013', 6371010, 6371, 63, 70241, 'JL KS TUBUN GG 1 TEBTRAM'),
(38, 70, '007', '005', '3273250003', 3273250, 3273, 32, 40153, 'JL BUDI LUHUR I BLK 15'),
(39, 71, '002', '004', '3205261002', 3205261, 3205, 32, 44185, 'KP. KANCIL'),
(40, 72, '009', '001', '6371030002', 6371030, 6371, 63, 70113, 'JL TELUK TIRAM DARAT GG PENDAMAI NO. 53'),
(41, 73, '004', '010', '3204130009', 3204130, 3204, 32, 40381, 'KOMP CIPARAY INDAH JL ANGGREK II B 136'),
(42, 74, '002', '002', '3329130002', 3329130, 3329, 33, 52253, 'PETUNJUNGAN'),
(43, 75, '004', '015', '3273150005', 3273150, 3273, 32, 40281, 'JL SETRAWANGI IV NO. 38'),
(44, 76, '005', '003', '3212030001', 3212030, 3212, 32, 45263, 'BLOK KEDUNG DAWA'),
(45, 77, '003', '006', '8102010037', 8102010, 8102, 81, 97611, 'PERUMNAS'),
(46, 12, '005', '002', '3520131012', 3520131, 3520, 35, 63394, 'jl. makam121'),
(47, 11, '002', '007', '3212150014', 3212150, 3212, 32, 45211, 'Bougenville merah no 5, perumahan citra dharma ayu'),
(48, 10, '001', '003', '3217070001', 3217070, 3217, 32, 40561, 'Sinarmukti No.7'),
(49, 8, '001', '012', '3207210012', 3207210, 3207, 32, 46214, 'LINGKUNGAN BOJONGSARI NO. 116'),
(50, 24, '006', '029', '3204290003', 3204290, 3204, 32, 40263, 'komp permata biru T2/40'),
(51, 13, '007', '011', '3273240004', 3273240, 3273, 32, 40162, 'JL KARANG TINGGAL DALAM'),
(52, 17, '006', '018', '3277030003', 3277030, 3277, 32, 40512, 'PERUMAHAN NUSA HIJAU PERMAI BLOK R NO. 17'),
(53, 15, '005', '009', '3204040010', 3204040, 3204, 32, 40378, 'Kp. Legok Kondang'),
(54, 18, '005', '015', '3204290002', 3204290, 3204, 32, 40624, 'Komp.Permata Biru Blok H No.129'),
(55, 26, '008', '001', '3273150002', 3273150, 3273, 32, 40285, 'JL SUKAPURA'),
(56, 14, '001', '007', '3273210006', 3273210, 3273, 32, 40125, 'JL BABAKAN BARU'),
(57, 22, '004', '002', '3277030002', 3277030, 3277, 32, 40513, 'JL. N. CIHANJUANG KOMP. DUTA REGENCY BLOK D 35'),
(58, 30, '002', '019', '3273141002', 3273141, 3273, 32, 40291, 'JL BANJARSARI 3 NO.24'),
(59, 16, '005', '003', '3273240001', 3273240, 3273, 32, 40164, 'JL CIBOGO ATAS NO.58'),
(60, 27, '003', '003', '3204180004', 3204180, 3204, 32, 40971, 'JL WARUNG LOBAK SUKARAJIN'),
(61, 20, '003', '016', '3204170002', 3204170, 3204, 32, 40376, 'KOMP. TIRTA REGENCY BLOK 0-11'),
(62, 25, '001', '019', '3204250006', 3204250, 3204, 32, 40216, 'JL LAGADAR RAYA D 25 KOMP. TABULA'),
(63, 28, '003', '014', '3204290001', 3204290, 3204, 32, 40626, 'KOMP. BUMI HARAPAN BLOK BB-10 NO. 20'),
(64, 29, '002', '001', '3204130002', 3204130, 3204, 32, 40381, 'KP KANGKARENG'),
(65, 31, '002', '001', '3204130002', 3204130, 3204, 32, 40381, 'KP KANGKARENG'),
(66, 23, '003', '007', '3217070005', 3217070, 3217, 32, 40561, 'BLOK KOMANDO NO. 69'),
(67, 79, '010', '001', '3273250001', 3273250, 3273, 32, 40151, 'PARAHYANGAN RUMAH VILA B-9'),
(68, 78, '010', '001', '3273250001', 3273250, 3273, 32, 40151, 'PARAHYANGAN RUMAH VILA B-9'),
(70, 21, '005', '008', '3205310014', 3205310, 3205, 32, 44188, 'KP MUNCANGAGUNG'),
(71, 80, '003', '001', '3525100009', 3525100, 3525, 35, 61114, 'JL KH WAHID HASYIM 3-A/02'),
(73, 19, '008', '012', '3204280002', 3204280, 3204, 32, 40288, 'KOMP BSA-II'),
(74, 83, '001', '002', '3204260004', 3204260, 3204, 32, 40226, 'JLN TERUSAN KOPO NO.380'),
(75, 84, '004', '001', '5312020001', 5312020, 5312, 53, 86413, 'BAJAWA');

--
-- Trigger `users_alamat`
--
DELIMITER $$
CREATE TRIGGER `delete_to_log_users_alamat` AFTER DELETE ON `users_alamat` FOR EACH ROW INSERT INTO log_data 
            (`id_data`, `field`, `status`)  
        VALUES 
            (OLD.id, "users_alamat", "delete")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_to_log_users_alamat` BEFORE INSERT ON `users_alamat` FOR EACH ROW INSERT INTO log_data 
            (`id_data`, `field`, `status`)  
        VALUES 
            (NEW.id, "users_alamat", "insert")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_to_log_users_alamat` AFTER UPDATE ON `users_alamat` FOR EACH ROW INSERT INTO log_data
            (`id_data`, `field`, `status`)  
        VALUES 
            (OLD.id, "users_alamat", "update")
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users_status_pegawai`
--

CREATE TABLE `users_status_pegawai` (
  `id` int(11) NOT NULL,
  `id_karyawan` int(11) NOT NULL,
  `tgl_masuk` datetime NOT NULL,
  `tgl_habis_kontrak` datetime NOT NULL,
  `status_pegawai` enum('tetap','kontrak') NOT NULL,
  `masa_kerja` varchar(50) NOT NULL,
  `id_cabang` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `users_status_pegawai`
--

INSERT INTO `users_status_pegawai` (`id`, `id_karyawan`, `tgl_masuk`, `tgl_habis_kontrak`, `status_pegawai`, `masa_kerja`, `id_cabang`) VALUES
(1, 8, '2019-03-11 00:00:00', '2021-03-11 00:00:00', 'kontrak', '-', 1),
(2, 10, '2006-06-10 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(3, 11, '2019-02-25 00:00:00', '2021-02-25 00:00:00', 'kontrak', '-', 1),
(4, 12, '2019-03-11 00:00:00', '2021-03-11 00:00:00', 'kontrak', '-', 1),
(5, 13, '2019-04-09 00:00:00', '2021-01-02 00:00:00', 'kontrak', '-', 1),
(6, 14, '2019-07-16 00:00:00', '2021-01-21 00:00:00', 'kontrak', '-', 1),
(7, 15, '2019-12-30 00:00:00', '2021-01-02 00:00:00', 'kontrak', '-', 1),
(8, 16, '2020-01-13 00:00:00', '2021-01-13 00:00:00', 'kontrak', '-', 1),
(9, 17, '2020-01-20 00:00:00', '2021-01-20 00:00:00', 'kontrak', '-', 1),
(10, 18, '2004-11-01 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(12, 20, '2006-08-07 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(13, 21, '2019-10-24 00:00:00', '2021-10-24 00:00:00', 'kontrak', '-', 1),
(14, 22, '1991-09-29 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(15, 23, '2017-06-03 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(16, 24, '2004-04-12 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(17, 25, '2017-05-17 00:00:00', '2021-05-31 00:00:00', 'kontrak', '-', 1),
(18, 26, '2015-09-07 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(19, 27, '2015-01-05 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(20, 28, '2015-02-11 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(21, 29, '2007-06-11 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(22, 30, '2018-10-29 00:00:00', '2021-04-02 00:00:00', 'kontrak', '-', 1),
(23, 31, '2014-09-15 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(24, 32, '2014-09-15 00:00:00', '0000-00-00 00:00:00', 'tetap', '5 tahun, 11 bulan', 2),
(25, 33, '2020-02-17 00:00:00', '2021-03-01 00:00:00', 'kontrak', '-', 1),
(26, 34, '2020-02-17 00:00:00', '2021-03-02 00:00:00', 'kontrak', '-', 1),
(27, 35, '2020-03-17 00:00:00', '2021-03-03 00:00:00', 'kontrak', '-', 1),
(29, 37, '2015-03-25 00:00:00', '2021-06-02 00:00:00', 'kontrak', '-', 1),
(31, 39, '2018-12-28 00:00:00', '2020-12-31 00:00:00', 'kontrak', '-', 1),
(32, 40, '2020-01-20 00:00:00', '2021-01-20 00:00:00', 'kontrak', '-', 1),
(36, 44, '2020-03-02 00:00:00', '2021-03-02 00:00:00', 'kontrak', '-', 1),
(37, 45, '2020-04-13 00:00:00', '2022-04-09 00:00:00', 'kontrak', '-', 1),
(38, 46, '2020-05-04 00:00:00', '2020-12-31 00:00:00', 'kontrak', '-', 1),
(39, 47, '2019-02-27 00:00:00', '2021-02-26 00:00:00', 'kontrak', '-', 1),
(40, 48, '2016-08-04 00:00:00', '2021-09-01 00:00:00', 'kontrak', '-', 1),
(41, 49, '2002-12-16 00:00:00', '2020-09-30 00:00:00', 'tetap', '-', 1),
(42, 50, '2002-12-01 00:00:00', '2020-09-30 00:00:00', 'tetap', '-', 1),
(43, 51, '2006-04-11 00:00:00', '2020-09-30 00:00:00', 'tetap', '-', 1),
(44, 52, '2016-03-30 00:00:00', '2021-06-30 00:00:00', 'kontrak', '-', 1),
(45, 53, '2003-04-01 00:00:00', '2020-09-30 00:00:00', 'tetap', '-', 1),
(46, 54, '2014-05-26 00:00:00', '2020-09-30 00:00:00', 'tetap', '-', 1),
(47, 55, '1994-02-01 00:00:00', '2020-09-30 00:00:00', 'tetap', '-', 1),
(48, 56, '2020-06-18 00:00:00', '2021-01-21 00:00:00', 'kontrak', '-', 1),
(49, 57, '2003-03-01 00:00:00', '2021-03-25 00:00:00', 'kontrak', '-', 2),
(50, 58, '2010-06-27 00:00:00', '2020-09-30 00:00:00', 'tetap', '-', 2),
(51, 59, '2014-09-11 00:00:00', '2021-10-23 00:00:00', 'kontrak', '-', 2),
(53, 61, '2019-06-18 00:00:00', '2021-06-19 00:00:00', 'kontrak', '-', 2),
(54, 62, '2012-12-17 00:00:00', '2021-01-20 00:00:00', 'kontrak', '-', 2),
(55, 63, '2012-03-01 00:00:00', '2020-09-30 00:00:00', 'tetap', '-', 2),
(56, 64, '2011-04-19 00:00:00', '2020-09-30 00:00:00', 'tetap', '-', 2),
(57, 65, '2007-08-01 00:00:00', '2020-09-30 00:00:00', 'tetap', '-', 2),
(58, 66, '2019-08-08 00:00:00', '2021-08-10 00:00:00', 'kontrak', '-', 2),
(59, 67, '2015-10-12 00:00:00', '2021-06-29 00:00:00', 'kontrak', '-', 2),
(60, 68, '2006-09-22 00:00:00', '2020-12-31 00:00:00', 'kontrak', '-', 2),
(62, 70, '2019-03-11 00:00:00', '2021-03-11 00:00:00', 'kontrak', '-', 2),
(63, 71, '2019-07-30 00:00:00', '2021-07-30 00:00:00', 'kontrak', '-', 2),
(64, 72, '2019-11-11 00:00:00', '2021-01-11 00:00:00', 'kontrak', '-', 2),
(65, 73, '2019-12-16 00:00:00', '2020-12-31 00:00:00', 'kontrak', '-', 2),
(66, 74, '2020-01-27 00:00:00', '2021-01-31 00:00:00', 'kontrak', '-', 2),
(67, 75, '2020-03-13 00:00:00', '2021-03-13 00:00:00', 'kontrak', '-', 2),
(68, 76, '2020-04-01 00:00:00', '2021-04-01 00:00:00', 'kontrak', '-', 2),
(69, 77, '2020-04-01 00:00:00', '2021-01-09 00:00:00', 'kontrak', '-', 2),
(70, 78, '1991-04-10 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(71, 79, '2019-11-25 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(72, 80, '2006-06-05 00:00:00', '2020-10-27 00:00:00', 'tetap', '-', 2),
(74, 19, '1995-06-01 00:00:00', '0000-00-00 00:00:00', 'tetap', '-', 1),
(75, 83, '2020-10-27 00:00:00', '2021-10-27 00:00:00', 'kontrak', '-', 2),
(76, 84, '2020-10-23 00:00:00', '2021-10-23 00:00:00', 'kontrak', '-', 2);

--
-- Trigger `users_status_pegawai`
--
DELIMITER $$
CREATE TRIGGER `delete_to_log_users_status_pegawai` AFTER DELETE ON `users_status_pegawai` FOR EACH ROW INSERT INTO log_data 
            (`id_data`, `field`, `status`)  
        VALUES 
            (OLD.id, "users_status_pegawai", "delete")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_to_log_users_status_pegawai` BEFORE INSERT ON `users_status_pegawai` FOR EACH ROW INSERT INTO log_data 
            (`id_data`, `field`, `status`)  
        VALUES 
            (NEW.id, "users_status_pegawai", "insert")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_to_log_users_status_pegawai` AFTER UPDATE ON `users_status_pegawai` FOR EACH ROW INSERT INTO log_data
            (`id_data`, `field`, `status`)  
        VALUES 
            (OLD.id, "users_status_pegawai", "update")
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `vendor`
--

CREATE TABLE `vendor` (
  `id` int(11) NOT NULL,
  `kode_vendor` varchar(20) NOT NULL,
  `nama_vendor` varchar(100) NOT NULL,
  `alamat_vendor` text NOT NULL,
  `deskripsi_vendor` text NOT NULL,
  `status_vendor` enum('0','1') NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `vendor`
--

INSERT INTO `vendor` (`id`, `kode_vendor`, `nama_vendor`, `alamat_vendor`, `deskripsi_vendor`, `status_vendor`, `created_at`, `updated_at`) VALUES
(1, 'RFID01', 'RFID TOTAL SOLUTION', 'Pelajar Pejuang no 43', 'vendor RFID', '1', '2021-01-22 00:00:00', '2021-01-22 00:00:00'),
(2, 'SFT01', 'Nuansa Cerah Informasi', 'Pelajar Pejuang no 43', 'vendor Software', '1', '2021-01-22 00:00:00', '2021-01-22 00:00:00');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `barang_epc_tag`
--
ALTER TABLE `barang_epc_tag`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `barang_kategori`
--
ALTER TABLE `barang_kategori`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `barang_satuan`
--
ALTER TABLE `barang_satuan`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `lokasi`
--
ALTER TABLE `lokasi`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indeks untuk tabel `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indeks untuk tabel `mutasi_barang`
--
ALTER TABLE `mutasi_barang`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `penerimaan_barang`
--
ALTER TABLE `penerimaan_barang`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `penerimaan_barang_detail`
--
ALTER TABLE `penerimaan_barang_detail`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `penerimaan_barang_detail_epc_tag`
--
ALTER TABLE `penerimaan_barang_detail_epc_tag`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `pengeluaran_barang`
--
ALTER TABLE `pengeluaran_barang`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `pengeluaran_barang_detail`
--
ALTER TABLE `pengeluaran_barang_detail`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `role_has_menus`
--
ALTER TABLE `role_has_menus`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indeks untuk tabel `stok_barang`
--
ALTER TABLE `stok_barang`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `unit`
--
ALTER TABLE `unit`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `users_alamat`
--
ALTER TABLE `users_alamat`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `users_status_pegawai`
--
ALTER TABLE `users_status_pegawai`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `vendor`
--
ALTER TABLE `vendor`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `barang`
--
ALTER TABLE `barang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `barang_epc_tag`
--
ALTER TABLE `barang_epc_tag`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `barang_kategori`
--
ALTER TABLE `barang_kategori`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `barang_satuan`
--
ALTER TABLE `barang_satuan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `penerimaan_barang`
--
ALTER TABLE `penerimaan_barang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `penerimaan_barang_detail`
--
ALTER TABLE `penerimaan_barang_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `penerimaan_barang_detail_epc_tag`
--
ALTER TABLE `penerimaan_barang_detail_epc_tag`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT untuk tabel `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `role_has_menus`
--
ALTER TABLE `role_has_menus`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `stok_barang`
--
ALTER TABLE `stok_barang`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT untuk tabel `users_alamat`
--
ALTER TABLE `users_alamat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT untuk tabel `users_status_pegawai`
--
ALTER TABLE `users_status_pegawai`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT untuk tabel `vendor`
--
ALTER TABLE `vendor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
