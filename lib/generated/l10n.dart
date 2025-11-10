// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Events`
  String get events {
    return Intl.message('Events', name: 'events', desc: '', args: []);
  }

  /// `Explore`
  String get explore {
    return Intl.message('Explore', name: 'explore', desc: '', args: []);
  }

  /// `My Trips`
  String get myTrips {
    return Intl.message('My Trips', name: 'myTrips', desc: '', args: []);
  }

  /// `Shopping`
  String get shopping {
    return Intl.message('Shopping', name: 'shopping', desc: '', args: []);
  }

  /// `Promotions`
  String get promotions {
    return Intl.message('Promotions', name: 'promotions', desc: '', args: []);
  }

  /// `Leaderboard`
  String get leaderBoard {
    return Intl.message('Leaderboard', name: 'leaderBoard', desc: '', args: []);
  }

  /// `{price} JOD`
  String priceJOD(Object price) {
    return Intl.message(
      '$price JOD',
      name: 'priceJOD',
      desc: '',
      args: [price],
    );
  }

  /// `No trips available. Create a trip first!`
  String get noTripsAvailable {
    return Intl.message(
      'No trips available. Create a trip first!',
      name: 'noTripsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `View All`
  String get viewAll {
    return Intl.message('View All', name: 'viewAll', desc: '', args: []);
  }

  /// `Social Links`
  String get socialLinks {
    return Intl.message(
      'Social Links',
      name: 'socialLinks',
      desc: '',
      args: [],
    );
  }

  /// `Website`
  String get website {
    return Intl.message('Website', name: 'website', desc: '', args: []);
  }

  /// `Facebook`
  String get facebook {
    return Intl.message('Facebook', name: 'facebook', desc: '', args: []);
  }

  /// `Instagram`
  String get instagram {
    return Intl.message('Instagram', name: 'instagram', desc: '', args: []);
  }

  /// `Twitter`
  String get twitter {
    return Intl.message('Twitter', name: 'twitter', desc: '', args: []);
  }

  /// `Youtube`
  String get youtube {
    return Intl.message('Youtube', name: 'youtube', desc: '', args: []);
  }

  /// `Tiktok`
  String get tiktok {
    return Intl.message('Tiktok', name: 'tiktok', desc: '', args: []);
  }

  /// `Whatsapp`
  String get whatsapp {
    return Intl.message('Whatsapp', name: 'whatsapp', desc: '', args: []);
  }

  /// `Exit App`
  String get exitApp {
    return Intl.message('Exit App', name: 'exitApp', desc: '', args: []);
  }

  /// `Are you sure you want to exit the app?`
  String get exitAppConfirmation {
    return Intl.message(
      'Are you sure you want to exit the app?',
      name: 'exitAppConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Exit`
  String get exit {
    return Intl.message('Exit', name: 'exit', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Search categories`
  String get searchCategories {
    return Intl.message(
      'Search categories',
      name: 'searchCategories',
      desc: '',
      args: [],
    );
  }

  /// `Browse Categories`
  String get browseCategories {
    return Intl.message(
      'Browse Categories',
      name: 'browseCategories',
      desc: '',
      args: [],
    );
  }

  /// `{numberOfProducts} Products`
  String numberOfProducts(Object numberOfProducts) {
    return Intl.message(
      '$numberOfProducts Products',
      name: 'numberOfProducts',
      desc: '',
      args: [numberOfProducts],
    );
  }

  /// `Stores`
  String get stores {
    return Intl.message('Stores', name: 'stores', desc: '', args: []);
  }

  /// `Products`
  String get products {
    return Intl.message('Products', name: 'products', desc: '', args: []);
  }

  /// `Subcategory`
  String get subCategory {
    return Intl.message('Subcategory', name: 'subCategory', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `Buy Tickets ({price} JOD)`
  String buyTickets(Object price) {
    return Intl.message(
      'Buy Tickets ($price JOD)',
      name: 'buyTickets',
      desc: '',
      args: [price],
    );
  }

  /// `What you will find`
  String get whatWillYouFind {
    return Intl.message(
      'What you will find',
      name: 'whatWillYouFind',
      desc: '',
      args: [],
    );
  }

  /// `Parking`
  String get parking {
    return Intl.message('Parking', name: 'parking', desc: '', args: []);
  }

  /// `All Ages`
  String get allAges {
    return Intl.message('All Ages', name: 'allAges', desc: '', args: []);
  }

  /// `Play Area`
  String get playArea {
    return Intl.message('Play Area', name: 'playArea', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Event Days`
  String get eventDays {
    return Intl.message('Event Days', name: 'eventDays', desc: '', args: []);
  }

  /// `Day {index}`
  String day(Object index) {
    return Intl.message('Day $index', name: 'day', desc: '', args: [index]);
  }

  /// `This Event Features`
  String get thisEventFeatures {
    return Intl.message(
      'This Event Features',
      name: 'thisEventFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Organizer`
  String get organizer {
    return Intl.message('Organizer', name: 'organizer', desc: '', args: []);
  }

  /// `Add Event to Trip`
  String get addEventToTrip {
    return Intl.message(
      'Add Event to Trip',
      name: 'addEventToTrip',
      desc: '',
      args: [],
    );
  }

  /// `No trips available`
  String get noTripsAvailablePrompt {
    return Intl.message(
      'No trips available',
      name: 'noTripsAvailablePrompt',
      desc: '',
      args: [],
    );
  }

  /// `Create a trip first to add events`
  String get createTripFirst {
    return Intl.message(
      'Create a trip first to add events',
      name: 'createTripFirst',
      desc: '',
      args: [],
    );
  }

  /// `Select Trip`
  String get selectTrip {
    return Intl.message('Select Trip', name: 'selectTrip', desc: '', args: []);
  }

  /// `Choose a trip`
  String get chooseTrip {
    return Intl.message(
      'Choose a trip',
      name: 'chooseTrip',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get selectDate {
    return Intl.message('Select Date', name: 'selectDate', desc: '', args: []);
  }

  /// `Add Event`
  String get addEvent {
    return Intl.message('Add Event', name: 'addEvent', desc: '', args: []);
  }

  /// `Search events`
  String get searchEvents {
    return Intl.message(
      'Search events',
      name: 'searchEvents',
      desc: '',
      args: [],
    );
  }

  /// `Browse Events`
  String get browseEvents {
    return Intl.message(
      'Browse Events',
      name: 'browseEvents',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Upcoming`
  String get upcoming {
    return Intl.message('Upcoming', name: 'upcoming', desc: '', args: []);
  }

  /// `Past`
  String get past {
    return Intl.message('Past', name: 'past', desc: '', args: []);
  }

  /// `Event Details`
  String get eventDetails {
    return Intl.message(
      'Event Details',
      name: 'eventDetails',
      desc: '',
      args: [],
    );
  }

  /// `Related Destinations`
  String get relatedDestinations {
    return Intl.message(
      'Related Destinations',
      name: 'relatedDestinations',
      desc: '',
      args: [],
    );
  }

  /// `Learn More`
  String get learnMore {
    return Intl.message('Learn More', name: 'learnMore', desc: '', args: []);
  }

  /// `Search for events, places, or activities`
  String get searchPlaceholder {
    return Intl.message(
      'Search for events, places, or activities',
      name: 'searchPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Explore Locations`
  String get exploreLocations {
    return Intl.message(
      'Explore Locations',
      name: 'exploreLocations',
      desc: '',
      args: [],
    );
  }

  /// `Explore Amman Festival`
  String get exploreAmmanFestival {
    return Intl.message(
      'Explore Amman Festival',
      name: 'exploreAmmanFestival',
      desc: '',
      args: [],
    );
  }

  /// `Explore Top Events`
  String get exploreTopEvents {
    return Intl.message(
      'Explore Top Events',
      name: 'exploreTopEvents',
      desc: '',
      args: [],
    );
  }

  /// `Try Our New Places`
  String get tryOurNewPlaces {
    return Intl.message(
      'Try Our New Places',
      name: 'tryOurNewPlaces',
      desc: '',
      args: [],
    );
  }

  /// `Explore Products`
  String get exploreProducts {
    return Intl.message(
      'Explore Products',
      name: 'exploreProducts',
      desc: '',
      args: [],
    );
  }

  /// `Explore Top Categories`
  String get exploreTopCategories {
    return Intl.message(
      'Explore Top Categories',
      name: 'exploreTopCategories',
      desc: '',
      args: [],
    );
  }

  /// `Check out Our Promotions`
  String get checkOurPromotions {
    return Intl.message(
      'Check out Our Promotions',
      name: 'checkOurPromotions',
      desc: '',
      args: [],
    );
  }

  /// `Amman Shopping \nFestival`
  String get ammanShoppingFestival {
    return Intl.message(
      'Amman Shopping \nFestival',
      name: 'ammanShoppingFestival',
      desc: '',
      args: [],
    );
  }

  /// `Tap the middle button\nin the bottom`
  String get tapMiddleButton {
    return Intl.message(
      'Tap the middle button\nin the bottom',
      name: 'tapMiddleButton',
      desc: '',
      args: [],
    );
  }

  /// `Leaderboard`
  String get leaderboard {
    return Intl.message('Leaderboard', name: 'leaderboard', desc: '', args: []);
  }

  /// `Search users`
  String get searchUsers {
    return Intl.message(
      'Search users',
      name: 'searchUsers',
      desc: '',
      args: [],
    );
  }

  /// `{userPoints} pts`
  String userPoints(Object userPoints) {
    return Intl.message(
      '$userPoints pts',
      name: 'userPoints',
      desc: '',
      args: [userPoints],
    );
  }

  /// `{userVisits} visits`
  String userVisits(Object userVisits) {
    return Intl.message(
      '$userVisits visits',
      name: 'userVisits',
      desc: '',
      args: [userVisits],
    );
  }

  /// `Trip "{tripTitle}" added successfully!`
  String tripAddedSuccessfully(Object tripTitle) {
    return Intl.message(
      'Trip "$tripTitle" added successfully!',
      name: 'tripAddedSuccessfully',
      desc: '',
      args: [tripTitle],
    );
  }

  /// `Search trips by name`
  String get searchTripsByName {
    return Intl.message(
      'Search trips by name',
      name: 'searchTripsByName',
      desc: '',
      args: [],
    );
  }

  /// `Add new trip`
  String get addNewTrip {
    return Intl.message('Add new trip', name: 'addNewTrip', desc: '', args: []);
  }

  /// `No trips yet`
  String get noTripsYet {
    return Intl.message('No trips yet', name: 'noTripsYet', desc: '', args: []);
  }

  /// `No trips found`
  String get noTripsFound {
    return Intl.message(
      'No trips found',
      name: 'noTripsFound',
      desc: '',
      args: [],
    );
  }

  /// `Try adjusting your search terms`
  String get adjustSearchTerms {
    return Intl.message(
      'Try adjusting your search terms',
      name: 'adjustSearchTerms',
      desc: '',
      args: [],
    );
  }

  /// `Start planning your first adventure!`
  String get startPlanning {
    return Intl.message(
      'Start planning your first adventure!',
      name: 'startPlanning',
      desc: '',
      args: [],
    );
  }

  /// `Add Your First Trip`
  String get addYourFirstTrip {
    return Intl.message(
      'Add Your First Trip',
      name: 'addYourFirstTrip',
      desc: '',
      args: [],
    );
  }

  /// `No Events`
  String get noEvents {
    return Intl.message('No Events', name: 'noEvents', desc: '', args: []);
  }

  /// `{numberOfEvents} Events`
  String numberOfEvents(Object numberOfEvents) {
    return Intl.message(
      '$numberOfEvents Events',
      name: 'numberOfEvents',
      desc: '',
      args: [numberOfEvents],
    );
  }

  /// `No Destinations`
  String get noDestinations {
    return Intl.message(
      'No Destinations',
      name: 'noDestinations',
      desc: '',
      args: [],
    );
  }

  /// `{numberOfDestinations} Destinations`
  String numberOfDestinations(Object numberOfDestinations) {
    return Intl.message(
      '$numberOfDestinations Destinations',
      name: 'numberOfDestinations',
      desc: '',
      args: [numberOfDestinations],
    );
  }

  /// `Add New Trip`
  String get addNewTripTitle {
    return Intl.message(
      'Add New Trip',
      name: 'addNewTripTitle',
      desc: '',
      args: [],
    );
  }

  /// `Trip Title`
  String get tripTitle {
    return Intl.message('Trip Title', name: 'tripTitle', desc: '', args: []);
  }

  /// `Enter your trip title`
  String get enterTripTitle {
    return Intl.message(
      'Enter your trip title',
      name: 'enterTripTitle',
      desc: '',
      args: [],
    );
  }

  /// `Trip Description`
  String get tripDescription {
    return Intl.message(
      'Trip Description',
      name: 'tripDescription',
      desc: '',
      args: [],
    );
  }

  /// `Describe your trip plans...`
  String get describeYourTrip {
    return Intl.message(
      'Describe your trip plans...',
      name: 'describeYourTrip',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get startDate {
    return Intl.message('Start Date', name: 'startDate', desc: '', args: []);
  }

  /// `Select start date`
  String get selectStartDate {
    return Intl.message(
      'Select start date',
      name: 'selectStartDate',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get endDate {
    return Intl.message('End Date', name: 'endDate', desc: '', args: []);
  }

  /// `Select end date`
  String get selectEndDate {
    return Intl.message(
      'Select end date',
      name: 'selectEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Add Trip`
  String get addTrip {
    return Intl.message('Add Trip', name: 'addTrip', desc: '', args: []);
  }

  /// `No destinations for this day`
  String get noDestinationsForThisDay {
    return Intl.message(
      'No destinations for this day',
      name: 'noDestinationsForThisDay',
      desc: '',
      args: [],
    );
  }

  /// `Search promotions`
  String get searchPromotions {
    return Intl.message(
      'Search promotions',
      name: 'searchPromotions',
      desc: '',
      args: [],
    );
  }

  /// `Redeem`
  String get redeem {
    return Intl.message('Redeem', name: 'redeem', desc: '', args: []);
  }

  /// `Visit Amman`
  String get visitAmman {
    return Intl.message('Visit Amman', name: 'visitAmman', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Rate this product`
  String get rateThisProduct {
    return Intl.message(
      'Rate this product',
      name: 'rateThisProduct',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get noResultsFound {
    return Intl.message(
      'No results found',
      name: 'noResultsFound',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message('Select', name: 'select', desc: '', args: []);
  }

  /// `{number} selected`
  String selected(Object number) {
    return Intl.message(
      '$number selected',
      name: 'selected',
      desc: '',
      args: [number],
    );
  }

  /// `Select Time`
  String get selectTime {
    return Intl.message('Select Time', name: 'selectTime', desc: '', args: []);
  }

  /// `Destinations`
  String get destinations {
    return Intl.message(
      'Destinations',
      name: 'destinations',
      desc: '',
      args: [],
    );
  }

  /// `No events for this day`
  String get noEventsForThisDay {
    return Intl.message(
      'No events for this day',
      name: 'noEventsForThisDay',
      desc: '',
      args: [],
    );
  }

  /// `#{rank}`
  String rank(Object rank) {
    return Intl.message('#$rank', name: 'rank', desc: '', args: [rank]);
  }

  /// `Top Explorers`
  String get topExplorers {
    return Intl.message(
      'Top Explorers',
      name: 'topExplorers',
      desc: '',
      args: [],
    );
  }

  /// `All Time`
  String get allTime {
    return Intl.message('All Time', name: 'allTime', desc: '', args: []);
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `This Week`
  String get thisWeek {
    return Intl.message('This Week', name: 'thisWeek', desc: '', args: []);
  }

  /// `This Month`
  String get thisMonth {
    return Intl.message('This Month', name: 'thisMonth', desc: '', args: []);
  }

  /// `Restaurants`
  String get restaurants {
    return Intl.message('Restaurants', name: 'restaurants', desc: '', args: []);
  }

  /// `Cafes`
  String get cafes {
    return Intl.message('Cafes', name: 'cafes', desc: '', args: []);
  }

  /// `Attractions`
  String get attractions {
    return Intl.message('Attractions', name: 'attractions', desc: '', args: []);
  }

  /// `Explore Destinations`
  String get exploreDestinations {
    return Intl.message(
      'Explore Destinations',
      name: 'exploreDestinations',
      desc: '',
      args: [],
    );
  }

  /// `Search Destinations`
  String get searchDestinations {
    return Intl.message(
      'Search Destinations',
      name: 'searchDestinations',
      desc: '',
      args: [],
    );
  }

  /// `Culture`
  String get culture {
    return Intl.message('Culture', name: 'culture', desc: '', args: []);
  }

  /// `Historical`
  String get historical {
    return Intl.message('Historical', name: 'historical', desc: '', args: []);
  }

  /// `Adventure`
  String get adventure {
    return Intl.message('Adventure', name: 'adventure', desc: '', args: []);
  }

  /// `Nature`
  String get nature {
    return Intl.message('Nature', name: 'nature', desc: '', args: []);
  }

  /// `Discover`
  String get discover {
    return Intl.message('Discover', name: 'discover', desc: '', args: []);
  }

  /// `DAYS`
  String get days {
    return Intl.message('DAYS', name: 'days', desc: '', args: []);
  }

  /// `HOURS`
  String get hours {
    return Intl.message('HOURS', name: 'hours', desc: '', args: []);
  }

  /// `MIN`
  String get minutes {
    return Intl.message('MIN', name: 'minutes', desc: '', args: []);
  }

  /// `SEC`
  String get seconds {
    return Intl.message('SEC', name: 'seconds', desc: '', args: []);
  }

  /// `Explore Event`
  String get exploreEvent {
    return Intl.message(
      'Explore Event',
      name: 'exploreEvent',
      desc: '',
      args: [],
    );
  }

  /// `Top Picks for You`
  String get topPicksForYou {
    return Intl.message(
      'Top Picks for You',
      name: 'topPicksForYou',
      desc: '',
      args: [],
    );
  }

  /// `Event Ended`
  String get eventEnded {
    return Intl.message('Event Ended', name: 'eventEnded', desc: '', args: []);
  }

  /// `Ongoing`
  String get ongoing {
    return Intl.message('Ongoing', name: 'ongoing', desc: '', args: []);
  }

  /// `Ended`
  String get ended {
    return Intl.message('Ended', name: 'ended', desc: '', args: []);
  }

  /// `Activities`
  String get activities {
    return Intl.message('Activities', name: 'activities', desc: '', args: []);
  }

  /// `Activity`
  String get activity {
    return Intl.message('Activity', name: 'activity', desc: '', args: []);
  }

  /// `Sponsors`
  String get sponsors {
    return Intl.message('Sponsors', name: 'sponsors', desc: '', args: []);
  }

  /// `Sponsor`
  String get sponsor {
    return Intl.message('Sponsor', name: 'sponsor', desc: '', args: []);
  }

  /// `Add Destination`
  String get addDestination {
    return Intl.message(
      'Add Destination',
      name: 'addDestination',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Continue as Guest`
  String get continueAsGuest {
    return Intl.message(
      'Continue as Guest',
      name: 'continueAsGuest',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to continue`
  String get signInToContinue {
    return Intl.message(
      'Sign in to continue',
      name: 'signInToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enterPhone {
    return Intl.message(
      'Enter your phone number',
      name: 'enterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message('Sign in', name: 'signIn', desc: '', args: []);
  }

  /// `Signing in...`
  String get signingIn {
    return Intl.message('Signing in...', name: 'signingIn', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message('Sign up', name: 'signUp', desc: '', args: []);
  }

  /// `Email is required`
  String get emailRequired {
    return Intl.message(
      'Email is required',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is required`
  String get phoneRequired {
    return Intl.message(
      'Phone number is required',
      name: 'phoneRequired',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email address`
  String get invalidEmail {
    return Intl.message(
      'Invalid email address',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone number`
  String get invalidPhone {
    return Intl.message(
      'Invalid phone number',
      name: 'invalidPhone',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password is too short`
  String get passwordTooShort {
    return Intl.message(
      'Password is too short',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Register Now`
  String get registerNow {
    return Intl.message(
      'Register Now',
      name: 'registerNow',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get or {
    return Intl.message('OR', name: 'or', desc: '', args: []);
  }

  /// `First name is required`
  String get firstNameRequired {
    return Intl.message(
      'First name is required',
      name: 'firstNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `First name is too short`
  String get firstNameTooShort {
    return Intl.message(
      'First name is too short',
      name: 'firstNameTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Last name is required`
  String get lastNameRequired {
    return Intl.message(
      'Last name is required',
      name: 'lastNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Last name is too short`
  String get lastNameTooShort {
    return Intl.message(
      'Last name is too short',
      name: 'lastNameTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password is required`
  String get confirmPasswordRequired {
    return Intl.message(
      'Confirm password is required',
      name: 'confirmPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get createAccount {
    return Intl.message(
      'Create account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up to get started`
  String get signUpToGetStarted {
    return Intl.message(
      'Sign up to get started',
      name: 'signUpToGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get firstName {
    return Intl.message('First name', name: 'firstName', desc: '', args: []);
  }

  /// `Last name`
  String get lastName {
    return Intl.message('Last name', name: 'lastName', desc: '', args: []);
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Creating account...`
  String get creatingAccount {
    return Intl.message(
      'Creating account...',
      name: 'creatingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Google`
  String get google {
    return Intl.message('Google', name: 'google', desc: '', args: []);
  }

  /// `Apple`
  String get apple {
    return Intl.message('Apple', name: 'apple', desc: '', args: []);
  }

  /// `Request Reset`
  String get requestReset {
    return Intl.message(
      'Request Reset',
      name: 'requestReset',
      desc: '',
      args: [],
    );
  }

  /// `Sending reset Request...`
  String get sendingResetRequest {
    return Intl.message(
      'Sending reset Request...',
      name: 'sendingResetRequest',
      desc: '',
      args: [],
    );
  }

  /// `Choose Recovery Type`
  String get chooseRecoveryType {
    return Intl.message(
      'Choose Recovery Type',
      name: 'chooseRecoveryType',
      desc: '',
      args: [],
    );
  }

  /// `Request Password Reset`
  String get requestPasswordReset {
    return Intl.message(
      'Request Password Reset',
      name: 'requestPasswordReset',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Resetting Password...`
  String get resetingPassword {
    return Intl.message(
      'Resetting Password...',
      name: 'resetingPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new password`
  String get enterNewPassword {
    return Intl.message(
      'Enter your new password',
      name: 'enterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Explore Dealers`
  String get exploreDealers {
    return Intl.message(
      'Explore Dealers',
      name: 'exploreDealers',
      desc: '',
      args: [],
    );
  }

  /// `Discover trusted car dealers`
  String get discoverTrustedCarDealers {
    return Intl.message(
      'Discover trusted car dealers',
      name: 'discoverTrustedCarDealers',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
