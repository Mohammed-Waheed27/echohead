import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Features/auth/presentation/pages/splash_page.dart';
import '../../Features/auth/presentation/pages/welcome_page.dart';
import '../../Features/auth/presentation/pages/login_page.dart';
import '../../Features/auth/presentation/pages/register_page.dart';
import '../../Features/auth/presentation/pages/company_password_page.dart';
import '../../Features/auth/presentation/bloc/auth_bloc.dart';
import '../../Features/Admin/presentation/pages/admin_dashboard_page.dart';
import '../../Features/Superviser/presentation/pages/supervisor_dashboard_page.dart';
import '../../Features/Worker/presentation/pages/worker_dashboard_page.dart';
import '../../Features/user/presentation/pages/user_dashboard_page.dart';
import '../../core/shared/constants/user_types.dart';
import '../di/service_locator.dart';
import 'router_names.dart';

class AppRouter {
  static AuthBloc _createAuthBloc() {
    return AuthBloc(authRepository: ServiceLocator.authRepository);
  }

  static final GoRouter router = GoRouter(
    initialLocation: RouterNames.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RouterNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouterNames.welcome,
        builder: (context, state) => const WelcomePage(),
      ),
      // Login routes
      GoRoute(
        path: RouterNames.loginUser,
        builder: (context, state) => BlocProvider(
          create: (context) => _createAuthBloc()..add(const CheckAuthStatus()),
          child: const LoginPage(userType: UserType.user),
        ),
      ),
      GoRoute(
        path: RouterNames.loginEmployee,
        builder: (context, state) => BlocProvider(
          create: (context) => _createAuthBloc()..add(const CheckAuthStatus()),
          child: const LoginPage(userType: UserType.worker),
        ),
      ),
      GoRoute(
        path: RouterNames.loginManager,
        builder: (context, state) => BlocProvider(
          create: (context) => _createAuthBloc()..add(const CheckAuthStatus()),
          child: const LoginPage(userType: UserType.supervisor),
        ),
      ),
      // Company password routes
      GoRoute(
        path: RouterNames.companyPasswordManager,
        builder: (context, state) => const CompanyPasswordPage(
          userType: UserType.supervisor,
        ),
      ),
      GoRoute(
        path: RouterNames.companyPasswordEmployee,
        builder: (context, state) => const CompanyPasswordPage(
          userType: UserType.worker,
        ),
      ),
      // Registration routes
      GoRoute(
        path: RouterNames.registerUser,
        builder: (context, state) => BlocProvider(
          create: (context) => _createAuthBloc()..add(const CheckAuthStatus()),
          child: const RegisterPage(userType: UserType.user),
        ),
      ),
      GoRoute(
        path: RouterNames.registerEmployee,
        builder: (context, state) => BlocProvider(
          create: (context) => _createAuthBloc()..add(const CheckAuthStatus()),
          child: const RegisterPage(userType: UserType.worker),
        ),
      ),
      GoRoute(
        path: RouterNames.registerManager,
        builder: (context, state) => BlocProvider(
          create: (context) => _createAuthBloc()..add(const CheckAuthStatus()),
          child: const RegisterPage(userType: UserType.supervisor),
        ),
      ),
      // Dashboard routes
      GoRoute(
        path: RouterNames.dashboardAdmin,
        builder: (context, state) => BlocProvider(
          create: (context) => _createAuthBloc()..add(const CheckAuthStatus()),
          child: const AdminDashboardPage(),
        ),
      ),
      GoRoute(
        path: RouterNames.dashboardSupervisor,
        builder: (context, state) => BlocProvider(
          create: (context) => _createAuthBloc()..add(const CheckAuthStatus()),
          child: const SupervisorDashboardPage(),
        ),
      ),
      GoRoute(
        path: RouterNames.dashboardWorker,
        builder: (context, state) => BlocProvider(
          create: (context) => _createAuthBloc()..add(const CheckAuthStatus()),
          child: const WorkerDashboardPage(),
        ),
      ),
      GoRoute(
        path: RouterNames.dashboardUser,
        builder: (context, state) => BlocProvider(
          create: (context) => _createAuthBloc()..add(const CheckAuthStatus()),
          child: const UserDashboardPage(),
        ),
      ),
    ],
  );
}

