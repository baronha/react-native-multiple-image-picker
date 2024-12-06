/* eslint-disable react-native/no-inline-styles */
import React, { useState } from 'react'
import {
  LayoutAnimation,
  Platform,
  Text,
  SafeAreaView,
  Appearance,
  useColorScheme,
} from 'react-native'
import { TouchableOpacity } from 'react-native'
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
import { Button, CodeTag, Container, View } from './components'
import useTheme from './hook/useTheme'

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
  const [options, setOptions] = useImmer<Config>(defaultOptions)

  const colorScheme = useColorScheme()

  const onPressImage = (item: Result, index: number) => {
    console.log(item, index)
  }

  const onPicker = async () => {
    try {
      const response = await openPicker({
        ...options,
        selectedAssets: Array.isArray(images) ? images : [images],
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

      <ScrollView style={style.scrollView}>
        <View style={{ alignItems: 'center' }}>
          <ImageGrid
            dataImage={images}
            onPressImage={onPressImage}
            // spaceSize={10}
            containerStyle={{ marginTop: 3 }}
            width={Dimensions.get('window').width - 6}
            sourceKey={'path'}
            videoKey={'type'}
            prefixPath={Platform.OS === 'ios' ? 'file://' : ''}
            conditionCheckVideo={'video'}
            videoURLKey={'thumbnail'}
            showDelete
            onDeleteImage={onRemovePhoto}
          />
          <CodeTag>Hello</CodeTag>
        </View>
      </ScrollView>

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
  title: {
    fontWeight: '900',
    fontSize: 24,
    paddingVertical: 24,
    fontFamily: 'Avenir',
    color: '#cdac81',
    textAlign: 'center',
  },
  buttonOpen: {
    margin: 24,
  },
  scrollView: {
    flex: 1,
  },
})
