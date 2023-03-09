//
// CumulocityCoreLibrary.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2023 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public enum Cumulocity {
}

extension Cumulocity {

	public class Core {

		public static let shared = Core()

	    public var requestBuilder: URLRequestBuilder = URLRequestBuilder()
	    public var session: URLSession = URLSession.shared
	    public lazy var applications: ApplicationsFactory = ApplicationsFactory(with: self)
	    public lazy var measurements: MeasurementsFactory = MeasurementsFactory(with: self)
	    public lazy var alarms: AlarmsFactory = AlarmsFactory(with: self)
	    public lazy var tenants: TenantsFactory = TenantsFactory(with: self)
	    public lazy var users: UsersFactory = UsersFactory(with: self)
	    public lazy var audits: AuditsFactory = AuditsFactory(with: self)
	    public lazy var realtimeNotifications: RealtimenotificationsFactory = RealtimenotificationsFactory(with: self)
	    public lazy var events: EventsFactory = EventsFactory(with: self)
	    public lazy var notifications20: Notifications20Factory = Notifications20Factory(with: self)
	    public lazy var retentions: RetentionsFactory = RetentionsFactory(with: self)
	    public lazy var identity: IdentityFactory = IdentityFactory(with: self)
	    public lazy var deviceControl: DevicecontrolFactory = DevicecontrolFactory(with: self)
	    public lazy var inventory: InventoryFactory = InventoryFactory(with: self)

	    private init() {
	    }

		public class ApplicationsFactory {

			private var factory: Core

			public lazy var applicationsApi: ApplicationsApi = ApplicationsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var applicationVersionsApi: ApplicationVersionsApi = ApplicationVersionsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var applicationBinariesApi: ApplicationBinariesApi = ApplicationBinariesApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var bootstrapUserApi: BootstrapUserApi = BootstrapUserApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var currentApplicationApi: CurrentApplicationApi = CurrentApplicationApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class MeasurementsFactory {

			private var factory: Core

			public lazy var measurementsApi: MeasurementsApi = MeasurementsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class AlarmsFactory {

			private var factory: Core

			public lazy var alarmsApi: AlarmsApi = AlarmsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class TenantsFactory {

			private var factory: Core

			public lazy var tenantsApi: TenantsApi = TenantsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var tenantApplicationsApi: TenantApplicationsApi = TenantApplicationsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var trustedCertificatesApi: TrustedCertificatesApi = TrustedCertificatesApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var deviceStatisticsApi: DeviceStatisticsApi = DeviceStatisticsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var usageStatisticsApi: UsageStatisticsApi = UsageStatisticsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var optionsApi: OptionsApi = OptionsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var loginOptionsApi: LoginOptionsApi = LoginOptionsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var loginTokensApi: LoginTokensApi = LoginTokensApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var systemOptionsApi: SystemOptionsApi = SystemOptionsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class UsersFactory {

			private var factory: Core

			public lazy var currentUserApi: CurrentUserApi = CurrentUserApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var usersApi: UsersApi = UsersApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var groupsApi: GroupsApi = GroupsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var rolesApi: RolesApi = RolesApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var inventoryRolesApi: InventoryRolesApi = InventoryRolesApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class AuditsFactory {

			private var factory: Core

			public lazy var auditsApi: AuditsApi = AuditsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class RealtimenotificationsFactory {

			private var factory: Core

			public lazy var realtimeNotificationApi: RealtimeNotificationApi = RealtimeNotificationApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class EventsFactory {

			private var factory: Core

			public lazy var eventsApi: EventsApi = EventsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var attachmentsApi: AttachmentsApi = AttachmentsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class Notifications20Factory {

			private var factory: Core

			public lazy var subscriptionsApi: SubscriptionsApi = SubscriptionsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var tokensApi: TokensApi = TokensApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class RetentionsFactory {

			private var factory: Core

			public lazy var retentionRulesApi: RetentionRulesApi = RetentionRulesApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class IdentityFactory {

			private var factory: Core

			public lazy var identityApi: IdentityApi = IdentityApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var externalIDsApi: ExternalIDsApi = ExternalIDsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class DevicecontrolFactory {

			private var factory: Core

			public lazy var operationsApi: OperationsApi = OperationsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var bulkOperationsApi: BulkOperationsApi = BulkOperationsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var deviceCredentialsApi: DeviceCredentialsApi = DeviceCredentialsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var newDeviceRequestsApi: NewDeviceRequestsApi = NewDeviceRequestsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class InventoryFactory {

			private var factory: Core

			public lazy var managedObjectsApi: ManagedObjectsApi = ManagedObjectsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var binariesApi: BinariesApi = BinariesApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			public lazy var childOperationsApi: ChildOperationsApi = ChildOperationsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}
	}
}
