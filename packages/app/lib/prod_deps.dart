import 'package:domain/auth/member_id_repository.dart';
import 'package:domain/sso/sso_repository.dart';
import 'package:providers/app_deps.dart';
import 'package:domain/auth/auth_repository.dart';
import 'package:domain/auth/login_progress_repository.dart';
import 'package:domain/bcs/bcs_repository.dart';
import 'package:domain/bank_account/bank_account_repository.dart';
import 'package:domain/current_address/current_address_repository.dart';
import 'package:domain/delivery_address/delivery_address_repository.dart';
import 'package:domain/external_service/external_service_repository.dart';
import 'package:domain/home_swap/home_swap_repository.dart';
import 'package:domain/mail_address/mail_address_repository.dart';
import 'package:domain/np_fan_club/np_fan_club_repository.dart';
import 'package:domain/notification/notification_repository.dart';
import 'package:domain/password_change/password_change_repository.dart';
import 'package:domain/prefecture/prefecture_repository.dart';
import 'package:domain/credit_card/credit_card_repository.dart';
import 'package:domain/top/top_page_repository.dart';
import 'package:domain/wallet/wallet_repository.dart';
import 'package:domain/welcome_call/welcome_call_repository.dart';
import 'package:domain/zip_code/zip_code_repository.dart';
import 'package:domain/salon/salon_repository.dart';
import 'package:domain/account_info/account_info_repository.dart';

class ProdDeps implements AppDeps {
  @override
  final AuthRepository authRepository;
  @override
  final LoginProgressRepository loginProgressRepository;
  @override
  final MemberIdRepository memberIdRepository;
  @override
  final BcsRepository bcsRepository;
  @override
  final BankAccountRepository bankAccountRepository;
  @override
  final CurrentAddressRepository currentAddressRepository;
  @override
  final DeliveryAddressRepository deliveryAddressRepository;
  @override
  final ExternalServiceRepository externalServiceRepository;
  @override
  final HomeSwapRepository homeSwapRepository;
  @override
  final MailAddressRepository mailAddressRepository;
  @override
  final NpFanClubRepository npFanClubRepository;
  @override
  final NotificationRepository notificationRepository;
  @override
  final PasswordChangeRepository passwordChangeRepository;
  @override
  final PrefectureRepository prefectureRepository;
  @override
  final CreditCardRepository creditCardRepository;
  @override
  final SsoRepository ssoRepository;
  @override
  final TopPageRepository topPageRepository;
  @override
  final WalletRepository walletRepository;
  @override
  final WelcomeCallRepository welcomeCallRepository;
  @override
  final ZipCodeRepository zipCodeRepository;
  @override
  final SalonRepository salonRepository;
  @override
  final AccountInfoRepository accountInfoRepository;

  ProdDeps({
    required this.authRepository,
    required this.loginProgressRepository,
    required this.memberIdRepository,
    required this.bcsRepository,
    required this.bankAccountRepository,
    required this.currentAddressRepository,
    required this.deliveryAddressRepository,
    required this.externalServiceRepository,
    required this.homeSwapRepository,
    required this.mailAddressRepository,
    required this.npFanClubRepository,
    required this.notificationRepository,
    required this.passwordChangeRepository,
    required this.prefectureRepository,
    required this.creditCardRepository,
    required this.ssoRepository,
    required this.topPageRepository,
    required this.walletRepository,
    required this.welcomeCallRepository,
    required this.zipCodeRepository,
    required this.salonRepository,
    required this.accountInfoRepository,
  });
}
