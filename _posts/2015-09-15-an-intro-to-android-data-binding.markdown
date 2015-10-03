---
layout: post
title:  An Intro to Android Data Binding
date: 2015-09-15T20:32:12-06:00
categories:
comments: true
author: tom_opgenorth
originalurl: http://www.opgenorth.net/blog/2015/06/21/android-data-binding-intro/
---

In May, 2015 at Google announced [a data binding library for Android](https://developer.android.com/tools/data-binding/guide.html). It's long overdue &ndash; developers no longer have to come up with their own schemes for displaying or retrieving data from their views. With two-way data binding, it's possible to remove a lot of redundant boilerplate code from the activities and fragments that make up an application.

_Just a warning - Android data binding is still a beta product, so as such things may or may not work when they should, as they should, and the documentation may or may not be accurate._

There were several steps/phases that I went through while I was learning this. Here's what I did:

1. **Add data binding to Android Studio** &ndash; This is a one time thing, a couple of lines in some Gradle files.
2. **Create a POJO for the binding** &ndash; You don't necessarily want to bind to a domain object. Arguable it's a cleaner design to have another class with responsiblity of data binding (and maybe some validation too). Model-View-ViewModel is an excellent pattern in this regard.
3. **Update the layout file** &ndash; We help the data binding library out by adding some meta-data/markup to our layout files.
4. **Update the activity to declare the data binding** &ndash; This will tell the data binding library how to connect the views to the POJO.

The [source code for this sample](https://github.com/topgenorth/drunken-bear) is up on Github.

# Adding Data Binding to Your Project

First off, make sure you're running Android Studio 1.3 or higher. As long as you're keeping current with the Android Studio

Next I had to edit the project's **build.gradle** file, my  `dependencies` section looks like this:

	dependencies {
	    classpath 'com.android.tools.build:gradle:1.3.1'
	    // TODO: when the final verison of dataBinder is release, change this to use a version number.
	    classpath 'com.android.databinding:dataBinder:1.+'
	}

After that, I updated the **build.gradle** for the app module. The first two line in the file are:

	apply plugin: 'com.android.application'
	apply plugin: 'com.android.databinding'

That's pretty much about it. Now that our project is aware of data binding, let's see about the code and UI changes I had to make.

# Using Data Binding

From here, you might be best off reading [Google's docs on data binding](https://developer.android.com/tools/data-binding/guide.html), just to get a feel for how things work. If you're familiar with data binding in XAML (say WPF or Xamarin.Forms), you might notice some simularities.

(*Allow me digress a bit and offer this piece of advice again: think twice about binding directly to your data model. This is a perfect opportunity to bring some Model-View-ViewModel goodness into your Android application. I'm not going to talk to much about MVVM though.*)

## Updating the Source Code

To keep my UI as code free as possible, I abstracted much of the data binding logic into the following class (his isn't all the code, just the parts relevant for this example):

{% highlight java %}
public class PhonewordViewModel extends BaseObservable {
    private boolean mIsTranslated = false;
    private String mPhoneNumber = "";
    private String mPhoneWord = "";
    private String mCallButtonText = "Call";

    @Bindable
    public String getPhoneNumber() {
        return mPhoneNumber;
    }

    @Bindable
    public String getCallButtonText() {
        return mCallButtonText;
    }

    @Bindable
    public boolean getIsTranslated() {
        return mIsTranslated;
    }

    @Bindable
    public String getPhoneWord() {
        return mPhoneWord;
    }


    public void setPhoneWord(String phoneWord) {
        mPhoneWord = phoneWord;
        onTranslate(null);

    }

    public void onTranslate(View v) {
        mPhoneNumber = toNumber(mPhoneWord);

        if (TextUtils.isEmpty(mPhoneNumber)) {
            mCallButtonText = "Call";
            mIsTranslated = false;
        } else {
            mIsTranslated = true;
            mCallButtonText = "Call " + mPhoneNumber + "?";
        }
        notifyPropertyChanged(net.opgenorth.phoneword.BR.phoneNumber);
        notifyPropertyChanged(net.opgenorth.phoneword.BR.isTranslated);
        notifyPropertyChanged(net.opgenorth.phoneword.BR.callButtonText);
    }
}
{% endhighlight %}

Here I've encapsulated logic into a view class that subclasses `BaseObservable`. Subclassing isn't mandatory &ndash; a naked POJO will work too. However, by making a custom view `BaseObservable` provides the infrastructure for setting up the data binding; and this custom view class can notify registered listeners as values change. As well, POJO's should be kept as dumb as possible without any intricate knowledge of views. By sticking the data binding logic in a view class like this I, honour the whole "separation of concerns" concept.

Notice that the getters are adorned with the `@Bindable` annotation - this identifies how the listeners should retrieve values from the properties.

It's the responsibility of the bound class to notify clients when a property has changed. You can see this happening with the use of `notifyPropertyChanged`. This causes a signal to be raised to listeners; this is how they find out the name has changed.

The `BR` class is generated by the data binding library. It is to data binding what the `R` class is to layout files. Each POJO field or method adorned with `@Bindable` will have a constant declared in the `BR` class at compile time corresponding to the name. So, `getPhoneNumber()` becomes `BR.phoneNumber`.

With the code out of the way, it's time to update the layout.

## Update the XML Layout

There were a couple of changes that I needed to make to my existing layout for things to work:

1. Declare some variables in my layout.
2. Identify properties on the various widgets that will be bound to the variable declared above.
3. Establish the data binding in the Activity.

Android's data binding requires that `<layout>` be the root element of the layout. My old layout started with a `<LinearLayout>`. It's also necessary to add a `<data/>` section that will declare variables and the classes that will be bound to.

### Declare A Variable

We need to declare a variable that the data binding framework can... bind too. I had to add a `<data>` element with a child `<variable>` element that names the variable and identifies the type Android should use for the binding:


{% highlight xml %}
<layout xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:app="http://schemas.android.com/apk/res-auto">
	<data>
		<variable
			name="phonewordVM"
			type="net.opgenorth.phoneword.PhonewordViewModel" />
	</data>

	<!-- my old layout is here, but omitted for clarity -->

</layout>
{% endhighlight %}

This declares a variable `phonewordVM` that I can use inside my layout file.

Notice that the `xmlns:app="http://schemas.android.com/apk/res-auto"` will automatically drag local namespaces into your XML. This helps you out a bit because you don't have to explicitly declare all the namespaces in layout file.

### Declare the Bindings in the Layout

Next, I need to set up the binding. In this example, all I want to do is to bind `setPhoneWord()`/`getPhoneWord()` in my custom view class to an `EditText`. This little XML snippet shows the binding in action:

{% highlight xml %}
<EditText
	android:id="@+id/phoneword_text"
	android:layout_width="fill_parent"
	android:layout_height="wrap_content"
	android:layout_marginLeft="10dp"
	android:layout_marginRight="10dp"
	android:hint="@string/phoneword_label_text"
	android:text="@{phonewordVM.phoneWord}"
	tools:ignore="TextFields" />
{% endhighlight %}

Notice the syntax to declare the binding: `@{phonewordVM.phoneWord}` &ndash; this is how I setup the binding in the layout file. With this in place, the last thing to do is to setup the data binding in the activity.

# Establish the Data Binding

Finally, setting up the data binding. This is a very minimal amount of code. We no longer have to first get a reference to a view, access properties on the view, and then manually transfer the value of that view to some domain object or variable in our application. Android Data Binding takes are of all that for me.

Below is a snippet from the fragment:

{% highlight java %}

public class MainActivityFragment extends Fragment {

    private PhonewordViewModel mPhonewordViewModel;
    private FragmentMainBinding mBinding;

    public MainActivityFragment() {
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        mPhonewordViewModel = new PhonewordViewModel();

        mBinding = DataBindingUtil.inflate(inflater, R.layout.fragment_main, container, false);
        mBinding.setPhonewordVM(mPhonewordViewModel);
        View v = mBinding.getRoot();

        mBinding.callButton.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        final Intent callIntent = new Intent(Intent.ACTION_CALL);
                        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(getActivity());
                        alertDialogBuilder
                                .setMessage(mBinding.callButton.getText())
                                .setNeutralButton(R.string.call_button_text, new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        callIntent.setData(Uri.parse("tel:" + mPhonewordViewModel.getPhoneNumber()));
                                        PhonewordUtils.savePhoneword(getActivity(), mPhonewordViewModel.getPhoneWord());
                                        startActivity(callIntent);
                                    }
                                })
                                .setNegativeButton(R.string.cancel_text, new DialogInterface.OnClickListener() {
                                    @Override
                                    public void onClick(DialogInterface dialog, int which) {
                                        // Nothing to do here.
                                    }
                                })
                                .show();
                    }
                }
        );


        mBinding.translateButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPhonewordViewModel.setPhoneWord(mBinding.phonewordText.getText().toString());
                mPhonewordViewModel.translatePhoneWord();
            }
        });

        return v;
    }
}

{% endhighlight %}

There are a couple of key things to notice here. First, observe that the fragment inflates a view called `fragment_main.xml`. The data binding library generates the code of a class called `FragmentMainBinding`. The name of the binding class is derived from the name of the layout file, with the work `Binding` appended to it.

Once the binding is instantiated, I tell it what object to bind to. The data binding library created a setter called `setPhonewordVM` &ndash; this is because we declared the variable `phonewordVM` in our layout file above.

Another interesting thing is that the code for the fragment does not use `findViewById` or hold a reference to any of the views layout. That is because the `FragmentMainBinding` has those references. So, for example, if I want to get the value of an `EditText` with the id `+@id/phonewordText`, then `mBinding.phonewordText.getText()` will do the trick.

I set the `OnClickListener` for the buttons in a very traditional way. In theory, the data binding library should allow to bind event listeners to methods on a view model. However, I have't been able to get that to work yet. Hopefully I'll have more luck next version of the data binding library (and/or an update to the docs for the data binding library)

# Sie Sind Fertig

With all this, data binding has been accomplished. It may seem like a lot of code, and perhaps it is for such a trivial example. Where the true power of this comes into play is when you want to write tests for your code. Two way data binding lays the framework for the Model-View-View Model pattern, which in turn helps you create a loosely coupled app that is easier to test.
