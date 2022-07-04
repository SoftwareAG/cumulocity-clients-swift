//
// CumulocityCoreLibrary.swift
// CumulocityCoreLibrary
//
// Copyright (c) 2014-2021 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
// Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
//

import Foundation

public enum Cumulocity {
}

extension Cumulocity {

	public class Core {

		static let shared = Core()

	    let requestBuilder: URLRequestBuilder = URLRequestBuilder()
	    var session: URLSession = URLSession.shared
	    lazy var applications: ApplicationsFactory = ApplicationsFactory(with: self)
	    lazy var measurements: MeasurementsFactory = MeasurementsFactory(with: self)
	    lazy var alarms: AlarmsFactory = AlarmsFactory(with: self)
	    lazy var tenants: TenantsFactory = TenantsFactory(with: self)
	    lazy var users: UsersFactory = UsersFactory(with: self)
	    lazy var audits: AuditsFactory = AuditsFactory(with: self)
	    lazy var realtimeNotifications: RealtimenotificationsFactory = RealtimenotificationsFactory(with: self)
	    lazy var events: EventsFactory = EventsFactory(with: self)
	    lazy var notifications20: Notifications20Factory = Notifications20Factory(with: self)
	    lazy var retentions: RetentionsFactory = RetentionsFactory(with: self)
	    lazy var identity: IdentityFactory = IdentityFactory(with: self)
	    lazy var deviceControl: DevicecontrolFactory = DevicecontrolFactory(with: self)
	    lazy var inventory: InventoryFactory = InventoryFactory(with: self)

	    private init() {
	    }

		public class ApplicationsFactory {

			private var factory: Core

			lazy var applicationsApi: ApplicationsApi = ApplicationsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var applicationBinariesApi: ApplicationBinariesApi = ApplicationBinariesApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var bootstrapUserApi: BootstrapUserApi = BootstrapUserApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var currentApplicationApi: CurrentApplicationApi = CurrentApplicationApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class MeasurementsFactory {

			private var factory: Core

			lazy var measurementsApi: MeasurementsApi = MeasurementsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class AlarmsFactory {

			private var factory: Core

			lazy var alarmsApi: AlarmsApi = AlarmsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class TenantsFactory {

			private var factory: Core

			lazy var tenantsApi: TenantsApi = TenantsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var tenantApplicationsApi: TenantApplicationsApi = TenantApplicationsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var deviceStatisticsApi: DeviceStatisticsApi = DeviceStatisticsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var usageStatisticsApi: UsageStatisticsApi = UsageStatisticsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var optionsApi: OptionsApi = OptionsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var loginOptionsApi: LoginOptionsApi = LoginOptionsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var systemOptionsApi: SystemOptionsApi = SystemOptionsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class UsersFactory {

			private var factory: Core

			lazy var currentUserApi: CurrentUserApi = CurrentUserApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var usersApi: UsersApi = UsersApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var groupsApi: GroupsApi = GroupsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var rolesApi: RolesApi = RolesApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var inventoryRolesApi: InventoryRolesApi = InventoryRolesApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class AuditsFactory {

			private var factory: Core

			lazy var auditsApi: AuditsApi = AuditsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class RealtimenotificationsFactory {

			private var factory: Core

			lazy var realtimeNotificationApi: RealtimeNotificationApi = RealtimeNotificationApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class EventsFactory {

			private var factory: Core

			lazy var eventsApi: EventsApi = EventsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var attachmentsApi: AttachmentsApi = AttachmentsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class Notifications20Factory {

			private var factory: Core

			lazy var subscriptionsApi: SubscriptionsApi = SubscriptionsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var tokensApi: TokensApi = TokensApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class RetentionsFactory {

			private var factory: Core

			lazy var retentionRulesApi: RetentionRulesApi = RetentionRulesApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class IdentityFactory {

			private var factory: Core

			lazy var identityApi: IdentityApi = IdentityApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var externalIDsApi: ExternalIDsApi = ExternalIDsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class DevicecontrolFactory {

			private var factory: Core

			lazy var operationsApi: OperationsApi = OperationsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var bulkOperationsApi: BulkOperationsApi = BulkOperationsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var deviceCredentialsApi: DeviceCredentialsApi = DeviceCredentialsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var newDeviceRequestsApi: NewDeviceRequestsApi = NewDeviceRequestsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}

		public class InventoryFactory {

			private var factory: Core

			lazy var inventoryApi: InventoryApi = InventoryApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var managedObjectsApi: ManagedObjectsApi = ManagedObjectsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var binariesApi: BinariesApi = BinariesApi(requestBuilder: factory.requestBuilder, withSession: factory.session)
			lazy var childOperationsApi: ChildOperationsApi = ChildOperationsApi(requestBuilder: factory.requestBuilder, withSession: factory.session)

			fileprivate init(with factory: Core) {
				self.factory = factory
			}
		}
	}
}
