import React, { useState } from 'react'
import {
  Appearance,
  ColorSchemeName,
  Image,
  LayoutAnimation,
  Platform,
  SafeAreaView,
  TextInput,
  TouchableOpacity,
  useColorScheme,
} from 'react-native'
import { Dimensions } from 'react-native'

import { StyleSheet } from 'react-native'
import ImageGrid from '@baronha/react-native-image-grid'
import {
  openPicker,
  Result,
  defaultOptions,
  Config,
} from '@baronha/react-native-multiple-image-picker'
import { useImmer } from 'use-immer'
import { StatusBar } from 'expo-status-bar'
import {
  Button,
  CodeTag,
  Container,
  CounterView,
  Input,
  SegmentControl,
  StickyView,
  Text,
  View,
} from './components'
import useTheme from './hook/useTheme'
import assets from './assets'
import Animated, {
  useAnimatedScrollHandler,
  useSharedValue,
} from 'react-native-reanimated'
import { WIDTH } from './theme/size'
import { IS_IOS } from './common/const'
import { AppContext } from './hook/context'
import SectionView from './components/SectionView'

const layoutEffect = () => {
  LayoutAnimation.configureNext({
    duration: 350,
    create: {
      type: LayoutAnimation.Types.easeInEaseOut,
      property: LayoutAnimation.Properties.opacity,
    },
    update: {
      type: LayoutAnimation.Types.easeInEaseOut,
    },
  })
}

export default function App() {
  const { background } = useTheme()
  const [images, setImages] = useState<Result[]>([])
  const [options, changeOptions] = useImmer<Config>(defaultOptions)
  const scrollY = useSharedValue(0)

  const colorScheme = useColorScheme()

  const onScroll = useAnimatedScrollHandler(
    {
      onScroll: (e) => {
        scrollY.value = e.contentOffset.y
      },
    },
    []
  )

  const setOptions = (key: keyof Config, value: Config[keyof Config]) => {
    changeOptions((draft) => {
      draft[key] = value as any
    })
  }

  const onPressImage = (item: Result, index: number) => {
    console.log(item, index)
  }

  const onPicker = async () => {
    try {
      const response = await openPicker({
        ...options,
        selectedAssets: images,
      })

      setImages(Array.isArray(response) ? response : [response])
      layoutEffect()
    } catch (e) {
      console.log('e: ', e)
    }
  }

  const onRemovePhoto = (_: Result, index: number) => {
    const data = [...images].filter((_, idx) => idx !== index)
    setImages(data)
  }

  const onChangeTheme = (value: string) => {
    Appearance.setColorScheme(value as ColorSchemeName)
  }

  return (
    <Container>
      <SafeAreaView />
      {Platform.OS === 'android' && (
        <StatusBar
          translucent={false}
          networkActivityIndicatorVisible
          backgroundColor={background}
        />
      )}

      <View style={style.titleView}>
        <Image source={assets.logo} style={style.logo} />

        <View style={style.textView}>
          <Text style={style.mip}>Multiple Image Picker</Text>
          <CodeTag textProps={{ style: { fontSize: 8 } }}>BY BAOHA</CodeTag>
        </View>
        <StickyView scrollY={scrollY} images={images} />
      </View>

      <AppContext.Provider value={{ options, setOptions }}>
        <Animated.ScrollView
          showsVerticalScrollIndicator={false}
          contentContainerStyle={style.scrollView}
          onScroll={onScroll}
          scrollEventThrottle={16}
        >
          {images.length > 0 ? (
            <ImageGrid
              dataImage={images}
              onPressImage={onPressImage}
              width={WIDTH - 6}
              sourceKey={'path'}
              videoKey={'type'}
              prefixPath={Platform.OS === 'ios' ? 'file://' : ''}
              conditionCheckVideo={'video'}
              videoURLKey={'thumbnail'}
              showDelete
              onDeleteImage={onRemovePhoto}
            />
          ) : (
            <TouchableOpacity style={style.buttonPlus} onPress={onPicker}>
              <Image source={assets.plusSign} style={style.plusSign} />
            </TouchableOpacity>
          )}

          <View style={style.content}>
            <Text style={style.title}>Config</Text>

            {/* mediaType */}

            <View style={style.section}>
              <SectionView
                title="mediaType"
                description="The type of media that can be selected."
              />
              <SegmentControl
                selectedIndex={
                  ['all', 'image', 'video'].indexOf(options.mediaType ?? '') ??
                  0
                }
                values={['all', 'image', 'video']}
                onValueChange={(value) => setOptions('mediaType', value)}
              />
            </View>

            {/* theme */}
            <View style={style.section}>
              <SectionView
                title="theme"
                description="Theme mode for the picker."
              />
              <SegmentControl
                selectedIndex={
                  ['light', 'dark'].indexOf(colorScheme ?? '') ?? 0
                }
                values={['light', 'dark']}
                onValueChange={onChangeTheme}
              />
            </View>

            {/* selectMode */}
            <View style={style.section}>
              <SectionView
                title="selectMode"
                description="Mode of selection in the picker."
              />
              <SegmentControl
                selectedIndex={
                  ['single', 'multiple'].indexOf(options.selectMode ?? '') ?? 0
                }
                values={['single', 'multiple']}
                onValueChange={(value) => setOptions('selectMode', value)}
              />
            </View>

            {/* selectBoxStyle */}
            <View style={style.section}>
              <SectionView
                title="selectBoxStyle"
                description="Select box style for the picker."
                optionKey="selectBoxStyle"
                segmentControl={['number', 'tick']}
              />
            </View>

            {/* presentation */}
            {IS_IOS ? (
              <SectionView
                title="presentation"
                description="Presentation style for the picker."
                optionKey="presentation"
                segmentControl={['fullScreenModal', 'formSheet']}
              />
            ) : null}

            {/* allowedCamera */}

            <SectionView
              title="allowedCamera"
              description="Enable camera functionality."
              optionKey="allowedCamera"
            />

            {IS_IOS ? (
              <>
                {/* allowedLimit */}
                <SectionView
                  title="allowedLimit"
                  description="Display additional select more media when permission on iOS is limited."
                  optionKey="allowedLimit"
                />
              </>
            ) : null}

            {/* allowSwipeToSelect */}
            <SectionView
              title="allowSwipeToSelect"
              description="Allow swipe to select media."
              optionKey="allowSwipeToSelect"
            />

            {/* isHiddenOriginalButton */}
            <SectionView
              title="isHiddenOriginalButton"
              description="Hide the original button in the picker."
              optionKey="isHiddenOriginalButton"
            />

            {/* maxSelect */}
            <SectionView
              title="maxSelect"
              description="The maximum number of media that can be selected."
            >
              <CounterView
                range={{ min: 1 }}
                value={options.maxSelect}
                onChange={(value) => setOptions('maxSelect', value)}
              />
            </SectionView>

            {/* maxVideo */}
            <SectionView
              title="maxVideo"
              description="The maximum number of video that can be selected."
            >
              <CounterView
                range={{ min: 1 }}
                value={options.maxVideo}
                onChange={(value) => setOptions('maxVideo', value)}
              />
            </SectionView>

            {/* numberOfColumn */}
            <SectionView
              title="numberOfColumn"
              description="The number of columns in the picker."
            >
              <CounterView
                range={{ min: 1, max: 10 }}
                value={options.numberOfColumn}
                onChange={(value) => setOptions('numberOfColumn', value)}
              />
            </SectionView>

            {/* spacing */}
            <SectionView
              title="spacing"
              description="The spacing between the media in the picker."
            >
              <CounterView
                range={{ min: 1, max: 10 }}
                value={options.spacing ?? 2}
                onChange={(value) => setOptions('spacing', value)}
              />
            </SectionView>

            {/* Preview */}
            <Text style={style.title}>Preview 🌠</Text>
            {/* isPreview */}
            <SectionView
              title="isPreview"
              description="Hide the preview button in the picker."
              optionKey="isPreview"
            />

            {/* isShowPreviewList */}
            <SectionView
              title="isShowPreviewList"
              description="Show the preview list."
              optionKey="isShowPreviewList"
            />

            {/* isHiddenPreviewButton */}
            <SectionView
              title="isHiddenPreviewButton"
              description="Hide the preview button in the picker."
              optionKey="isHiddenPreviewButton"
            />

            {/* allowHapticTouchPreview */}
            {IS_IOS ? (
              <SectionView
                title="allowHapticTouchPreview"
                description="Allow haptic touch preview."
                optionKey="allowHapticTouchPreview"
              />
            ) : null}

            <Text style={style.title}>Compress Quality 🤐</Text>

            <Text style={style.title}>Localization 🌐</Text>
          </View>
        </Animated.ScrollView>
      </AppContext.Provider>

      <View level={2}>
        <Button style={style.buttonOpen} onPress={onPicker}>
          Open Picker
        </Button>
        <SafeAreaView />
      </View>
    </Container>
  )
}

const style = StyleSheet.create({
  titleView: {
    padding: 16,

    flexDirection: 'row',
    gap: 12,
  },
  mip: {
    // flex: 1,
  },
  textView: {
    alignItems: 'flex-start',
    flex: 1,
    height: 48,
    gap: 4,
  },
  title: {
    fontWeight: 900,
    fontSize: 20,
    fontFamily: 'Avenir',
    textTransform: 'uppercase',
    paddingTop: 12,
  },
  buttonOpen: {
    margin: 16,
  },
  scrollView: {
    gap: 12,
    paddingTop: 12,
    paddingBottom: 24,
  },
  content: {
    flexDirection: 'column',
    gap: 32,
    padding: 16,
  },

  logo: {
    aspectRatio: 1,
    objectFit: 'cover',
    height: 48,
    width: 48,
  },
  buttonPlus: {
    alignItems: 'center',
    justifyContent: 'center',
    padding: 48,
    marginHorizontal: 16,
    // backgroundColor: '#D4D4D432',
    borderStyle: 'dashed',
    borderWidth: 2,
    borderColor: '#D4D4D492',
    borderRadius: 8,
  },
  plusSign: {
    width: 16,
    height: 16,
  },
  section: {
    rowGap: 12,
    columnGap: 24,
  },
  sectionTitle: {
    gap: 8,
  },

  des: {
    fontSize: 12,
    // marginBottom: 12,
  },
})
