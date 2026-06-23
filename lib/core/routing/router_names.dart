class RouterNames {
  // Main Routes
  static const String home = '/home';

  // Auth Routes
  static const String splash = '/splash';
  static const String onboardingWelcome = '/onboarding-welcome';
  static const String welcome = '/welcome';

  // Login Routes
  static const String loginUser = '/login/user';
  static const String loginEmployee = '/login/employee';
  static const String loginManager = '/login/manager';
  static const String forgotPassword = '/forgot-password';

  // Company Password Routes
  static const String companyPasswordManager = '/company-password/manager';
  static const String companyPasswordEmployee = '/company-password/employee';

  // Registration Routes
  static const String registerUser = '/register/user';
  static const String registerEmployee = '/register/employee';
  static const String registerManager = '/register/manager';

  // Dashboard Routes
  static const String dashboardAdmin = '/dashboard/admin';
  static const String dashboardSupervisor = '/dashboard/supervisor';
  static const String dashboardWorker = '/dashboard/worker';
  static const String dashboardUser = '/dashboard/user';

  // Profile Routes
  static const String profileWorker = '/dashboard/worker/profile';
  static const String profileSupervisor = '/dashboard/supervisor/profile';

  // Worker Jobs
  static const String workerJobs = '/dashboard/worker/jobs';

  // Supervisor Pages
  static const String supervisorWorkerManagement =
      '/dashboard/supervisor/workers';
  static const String supervisorAddWorker = '/dashboard/supervisor/workers/add';
  static const String supervisorOverview = '/dashboard/supervisor/overview';
  static const String supervisorTasks = '/dashboard/supervisor/tasks';

  // User Features
  static const String reportIssue = '/report-issue';
  static const String reportHistory = '/report-history';

  // Admin Reports
  static const String adminReports = '/dashboard/admin/reports';

  // Worker Reports
  static const String workerReports = '/dashboard/worker/reports';
}
