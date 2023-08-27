import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_clone/src/common_widgets/async_value_widgets.dart';
import 'package:twitter_clone/src/core/core.dart';
import 'package:twitter_clone/src/features/auth/views/login_screen.dart';
import 'package:twitter_clone/src/features/tweet/views/tweet_reply_screen.dart';
import 'package:twitter_clone/src/repositories/repositories.dart';

import '../features/auth/views/signup_screen.dart';
import '../features/home/views/home_screen.dart';
import '../features/tweet/views/create_tweet_view.dart';
import '../repositories/tweet_repository.dart';

enum AppRoute { home, signUp, login, createTweet, tweet }

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    final auth = ref.watch(Repositories.auth);
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(auth.authStateChanges()),
      redirect: (context, state) {
        // If the user is not logged in, redirect to the login page
        if (auth.currentUser == null) {
          // Only allow the user to go to the login page or sign up page
          if (state.matchedLocation != '/login' &&
              state.matchedLocation != '/signUp') {
            return '/login';
          }
          return null;
        }
        // If the user comes from the login page or sign up page, redirect to the home page
        if (state.matchedLocation == '/login' ||
            state.matchedLocation == '/signUp') {
          return '/';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          name: AppRoute.home.name,
          builder: (context, state) => HomeScreen(
            key: state.pageKey,
          ),
          routes: [
            GoRoute(
              path: 'createTweet',
              name: AppRoute.createTweet.name,
              pageBuilder: (context, state) => CustomTransitionPage<void>(
                key: state.pageKey,
                child: const CreateTweetScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).chain(
                      CurveTween(curve: Curves.easeIn),
                    ),
                  ),
                  child: child,
                ),
              ),
            ),
            GoRoute(
              path: 'tweet/:id',
              name: AppRoute.tweet.name,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return Consumer(
                  builder: (context, ref, child) {
                    final tweetValue = ref.watch(getTweetProvider(id));
                    return AsyncValueScreen(
                      key: state.pageKey,
                      value: tweetValue,
                      data: (tweet) => TweetReplyScreen(tweet: tweet),
                    );
                  },
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/signUp',
          name: AppRoute.signUp.name,
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const SignUpScreen(),
          ),
        ),
        GoRoute(
          path: '/login',
          name: AppRoute.login.name,
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const LoginScreen(),
          ),
        ),
      ],
    );
  },
);
