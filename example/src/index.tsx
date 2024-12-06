/* eslint-disable react-native/no-inline-styles */
import React, { ReactNode, useState } from 'react'
import {
  Appearance,
  ColorSchemeName,
  Image,
  LayoutAnimation,
  Platform,
  SafeAreaView,
  TouchableOpacity,
  useColorScheme,
} from 'react-native'
import { ScrollView } from 'react-native'
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
  Row,
  SegmentControl,
  StickyView,
  Text,
  View,
} from './components'
import useTheme from './hook/useTheme'
import assets from './assets'
import Divider from './components/Divider'
import Animated, {
  useAnimatedScrollHandler,
  useSharedValue,
} from 'react-native-reanimated'
import { WIDTH } from './theme/size'

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

const { width } = Dimensions.get('window')

export default function App() {
  const { background, background_1 } = useTheme()
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
    Appearance.setColorScheme(
      (value === 'system' ? null : value) as ColorSchemeName
    )
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

          {/* theme */}
          <View style={style.section}>
            <CodeTag>theme</CodeTag>
            <Text style={style.des}>Theme mode for the picker</Text>

            <SegmentControl
              selectedIndex={['light', 'dark'].indexOf(colorScheme ?? '') ?? 0}
              values={['light', 'dark']}
              onValueChange={onChangeTheme}
            />
          </View>
        </View>
      </Animated.ScrollView>

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
    flex: 1,
  },
  textView: {
    alignItems: 'flex-start',
    justifyContent: 'space-between',
    flex: 1,
    height: 48,
  },
  title: {
    fontWeight: 900,
    fontSize: 20,
    fontFamily: 'Avenir',
    textTransform: 'uppercase',
  },
  buttonOpen: {
    margin: 16,
  },
  scrollView: {
    gap: 12,
  },
  content: {
    flexDirection: 'column',
    paddingHorizontal: 16,
    paddingBottom: 16,
    gap: 16,
    paddingTop: 16,
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
    gap: 12,
  },
  des: {},
})
