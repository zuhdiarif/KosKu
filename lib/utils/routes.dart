import 'package:flutter/material.dart';
import 'package:kosmo/models/kos_model.dart';
import 'package:kosmo/models/room_model.dart';
import 'package:kosmo/models/tenant_model.dart';
import 'package:kosmo/models/payment_model.dart';
import 'package:kosmo/views/auth/login_view.dart';
import 'package:kosmo/views/auth/register_view.dart';
import 'package:kosmo/views/auth/forgot_password_view.dart';
import 'package:kosmo/views/auth/verify_otp_view.dart';
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
  static const String verifyOtp = '/verify-otp';
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

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      case verifyOtp:
        final email = (settings.arguments as String?) ?? '';
        return MaterialPageRoute(builder: (_) => VerifyOtpView(email: email));
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardView());
      case kosList:
        return MaterialPageRoute(builder: (_) => const KosListView());
      case kosDetail:
        if (settings.arguments is KosModel) {
          final kos = settings.arguments as KosModel;
          return MaterialPageRoute(builder: (_) => KosDetailView(kos: kos));
        }
        return MaterialPageRoute(builder: (_) => const KosListView());
      case kosForm:
        final kos = settings.arguments as KosModel?;
        return MaterialPageRoute(builder: (_) => KosFormView(kos: kos));
      case roomList:
        final kosId = (settings.arguments as String?) ?? '';
        return MaterialPageRoute(builder: (_) => RoomListView(kosId: kosId));
      case roomDetail:
        if (settings.arguments is RoomModel) {
          final room = settings.arguments as RoomModel;
          return MaterialPageRoute(builder: (_) => RoomDetailView(room: room));
        }
        return MaterialPageRoute(builder: (_) => const KosListView());
      case roomForm:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(builder: (_) => RoomFormView(
          kosId: args['kosId'] as String? ?? '',
          room: args['room'] as RoomModel?,
        ));
      case tenantList:
        final kosId = (settings.arguments as String?) ?? '';
        return MaterialPageRoute(builder: (_) => TenantListView(kosId: kosId));
      case tenantDetail:
        if (settings.arguments is TenantModel) {
          final tenant = settings.arguments as TenantModel;
          return MaterialPageRoute(builder: (_) => TenantDetailView(tenant: tenant));
        }
        return MaterialPageRoute(builder: (_) => const KosListView());
      case tenantForm:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(builder: (_) => TenantFormView(
          kosId: args['kosId'] as String? ?? '',
          tenant: args['tenant'] as TenantModel?,
        ));
      case paymentList:
        return MaterialPageRoute(builder: (_) => const PaymentListView());
      case paymentDetail:
        if (settings.arguments is PaymentModel) {
          final payment = settings.arguments as PaymentModel;
          return MaterialPageRoute(builder: (_) => PaymentDetailView(payment: payment));
        }
        return MaterialPageRoute(builder: (_) => const PaymentListView());
      case paymentForm:
        final payment = settings.arguments as PaymentModel?;
        return MaterialPageRoute(builder: (_) => PaymentFormView(payment: payment));
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationView());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileView());
      default:
        return MaterialPageRoute(builder: (_) => const LoginView());
    }
  }
}
