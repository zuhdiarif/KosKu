import 'package:flutter/material.dart';
import 'package:kosmo/views/auth/login_view.dart';
import 'package:kosmo/views/auth/register_view.dart';
import 'package:kosmo/views/auth/forgot_password_view.dart';
import 'package:kosmo/views/dashboard/dashboard_view.dart';
import 'package:kosmo/views/kos/kos_list_view.dart';
import 'package:kosmo/views/kos/kos_detail_view.dart';
import 'package:kosmo/views/kos/kos_form_view.dart';
import 'package:kosmo/views/room/room_list_view.dart';
import 'package:kosmo/views/room/room_detail_view.dart';
import 'package:kosmo/views/room/room_form_view.dart';
import 'package:kosmo/views/tenant/tenant_list_view.dart';
import 'package:kosmo/views/tenant/tenant_detail_view.dart';
import 'package:kosmo/views/tenant/tenant_form_view.dart';
import 'package:kosmo/views/payment/payment_list_view.dart';
import 'package:kosmo/views/payment/payment_detail_view.dart';
import 'package:kosmo/views/payment/payment_form_view.dart';
import 'package:kosmo/views/notification/notification_view.dart';
import 'package:kosmo/views/profile/profile_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String kosList = '/kos';
  static const String kosDetail = '/kos/detail';
  static const String kosForm = '/kos/form';
  static const String roomList = '/room';
  static const String roomDetail = '/room/detail';
  static const String roomForm = '/room/form';
  static const String tenantList = '/tenant';
  static const String tenantDetail = '/tenant/detail';
  static const String tenantForm = '/tenant/form';
  static const String paymentList = '/payment';
  static const String paymentDetail = '/payment/detail';
  static const String paymentForm = '/payment/form';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginView(),
    register: (_) => const RegisterView(),
    forgotPassword: (_) => const ForgotPasswordView(),
    dashboard: (_) => const DashboardView(),
    kosList: (_) => const KosListView(),
    kosDetail: (_) => const KosDetailView(),
    kosForm: (_) => const KosFormView(),
    roomList: (_) => const RoomListView(),
    roomDetail: (_) => const RoomDetailView(),
    roomForm: (_) => const RoomFormView(),
    tenantList: (_) => const TenantListView(),
    tenantDetail: (_) => const TenantDetailView(),
    tenantForm: (_) => const TenantFormView(),
    paymentList: (_) => const PaymentListView(),
    paymentDetail: (_) => const PaymentDetailView(),
    paymentForm: (_) => const PaymentFormView(),
    notifications: (_) => const NotificationView(),
    profile: (_) => const ProfileView(),
  };
}
